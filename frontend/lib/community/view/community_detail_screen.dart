import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_comment_list_view_family.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../component/community_comment.dart';
import '../model/community_detail_model.dart';
import '../provider/community_comment_provider.dart';
import '../provider/community_detail_provider.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String id;

  static String get routeName => 'CommunityDetailScreen';

  const CommunityDetailScreen({super.key, required this.id});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen> {
  final ScrollController controller = ScrollController();
  final double horizontal = 16.0;
  late final DateTime dt;
  late final String formattedDate;

  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    formattedDate = DateFormat('yy년 M월 d일').format(dt);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityDetailProvider(widget.id).notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityDetailProvider(widget.id)).value?.data;

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator(),));
    }

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.close_outlined),
        ),
        elevation: 0,
        title: Text(
          '게시물',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      child: _content(state),
    );
  }

  Widget _content(CommunityDetailModel state) {
    final imageWidth = MediaQuery.of(context).size.width;
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          state.profileImage == null
                              ? Icon(Icons.account_circle_outlined, size: 32)
                              : Image.network(
                                state.profileImage!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.nickname, style: TextStyle(fontSize: 14)),
                        Text(
                          DateFormat('yy년 M월 d일').format(state.createdAt),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Image.network(
                state.imageUrl,
                fit: BoxFit.cover,
                width: imageWidth,
                height: imageWidth,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.only(left: horizontal),
          sliver: _tagDetail(state),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontal,
              vertical: 6.0,
            ),
            child: const Divider(thickness: 0.5, color: Colors.grey),
          ),
        ),

        _contentDetail(state),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontal,
              vertical: 6.0,
            ),
            child: const Divider(thickness: 0.5, color: Colors.grey),
          ),
        ),
        CommunityCommentListViewFamily(itemBuilder: <CommunityCommentModel>(_, index, model) {return CommunityComment.fromModel(model : model);}, provider: communityCommentProvider, childAspectRatio: 175/ 250, id: state.id.toString(),)

      ],
    );
  }

  Widget _tagDetail(CommunityDetailModel state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Container(width: 85, height: 85, color: Colors.grey),
                    SizedBox(
                      width: 210,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '간단하게 만드는 밥도둑, 팽이버섯 두부 조림',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4.0),
                              Text('설명 내역입니다', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contentDetail(CommunityDetailModel state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  state.commentCount.toString(),
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4.0),
                Icon(Icons.comment_outlined, size: 24),
                const SizedBox(width: 10.0),
                Text(
                  state.scrapCount.toString(),
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                state.scrapped
                    ? Icon(Icons.bookmark, size: 26)
                    : Icon(Icons.bookmark_border_outlined, size: 26),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 270,
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        state.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 350,
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        state.content,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
