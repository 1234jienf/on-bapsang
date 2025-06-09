import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../provider/community_detail_provider.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String id;

  static String get routeName => 'CommunityDetailScreen';

  const CommunityDetailScreen({super.key, required this.id});

  @override
  ConsumerState<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {ref.read(communityDetailProvider(widget.id).notifier).fetchData();});
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityDetailProvider(widget.id));

    print(state);

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
      child: _content(),
    );
  }

  Widget _content() {
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
                    Icon(Icons.account_circle_outlined, size: 32),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('user_0287', style: TextStyle(fontSize: 14)),
                        Text(formattedDate, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              Image.asset(
                'asset/img/community_detail_pic.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.only(left: horizontal),
          sliver: _tagDetail(),
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

        _contentDetail(),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontal,
              vertical: 6.0,
            ),
            child: const Divider(thickness: 0.5, color: Colors.grey),
          ),
        ),

        _comment(),
      ],
    );
  }

  Widget _tagDetail() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
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
                                "간단하게 만드는 밥도둑, 팽이버섯 두부 조림",
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

  Widget _contentDetail() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.comment_outlined, size: 24),
                Icon(Icons.bookmark_border_outlined, size: 26),
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
                        "간단하게 만드는 밥도둑, 팽이버섯 두부 조림",
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
                        "요리에 대한 소개 영역입니다. 요리에 대한 소개 영역입니다. 요리에 대한 소개 영역입니다. 요리에 대한 소개 영역입니다. 요리에 대한 소개 영역입니다.",
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

  Widget _comment() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: horizontal),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: 3,
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.account_circle_outlined, size: 32)],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('user_0287', style: TextStyle(fontSize: 14)),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: Text(
                            "댓글 영역입니다. 댓글 영역입니다. 댓글 영역입니다.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      // 하트 아이콘
                      Icon(Icons.favorite_border_outlined, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
