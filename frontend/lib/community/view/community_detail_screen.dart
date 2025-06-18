import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_comment_list_view_family.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/const/colors.dart';
import '../component/community_comment.dart';
import '../component/community_comment_inputbox.dart';
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
  final FocusNode replyFocusNode = FocusNode();

  int? _parentCommentId;
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityDetailProvider(widget.id).notifier).fetchData();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    replyFocusNode.dispose();
    super.dispose();
  }

  void _activateReplyMode(int parentCommentId, String nickname) {
    setState(() {
      _parentCommentId = parentCommentId;
      _nickname = nickname;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      replyFocusNode.requestFocus();
    });
  }

  void _deactivateReplyMode() {
    setState(() {
      _parentCommentId = null;
      _nickname = '';
    });
    replyFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityDetailProvider(widget.id)).value?.data;

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator()));
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
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_parentCommentId != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(
                    bottom: BorderSide(color: gray300, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 16, color: gray600),
                    SizedBox(width: 8),
                    Text(
                      '$_nickname님에게 답글',
                      style: TextStyle(fontSize: 14, color: gray600),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _deactivateReplyMode,
                      child: Icon(Icons.close, size: 18, color: gray600),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).viewInsets.bottom > 100
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0,
                left: 16,
                right: 16,
              ),
              child: _commentInput(context, widget.id),
            ),
          ],
        ),
      ),
      child: _content(state),
    );
  }

  Widget _commentInput(BuildContext context, String id) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      alignment: Alignment.center,
      child: CommunityCommentInputbox(
        contentWord: _parentCommentId != null  // 🆕 수정
            ? '대댓글을 입력하세요'
            : '댓글을 달아주세요',
        commentId: _parentCommentId,
        replyFocusNode: _parentCommentId != null ? replyFocusNode : null,
        id: id,
        onCommentSubmit: _deactivateReplyMode,
      ),
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
            child: Column(
              children: [
                const Divider(thickness: 0.5, color: Colors.grey),
              ],
            ),
          ),
        ),
        CommunityCommentListViewFamily(
          itemBuilder: <CommunityCommentModel>(_, index, model) {
            return GestureDetector(
              onLongPress: () {
                _activateReplyMode(model.id, model.nickname);
              },
              child: Container(
                color: _parentCommentId == model.id
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                child: CommunityComment.fromModel(model: model),
              ),
            );
          },
          provider: communityCommentProvider,
          childAspectRatio: 175 / 250,
          id: state.id.toString(),
        ),
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
                    Image.network(
                      state.recipeImageUrl,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 210,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.recipeTag,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
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
