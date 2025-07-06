import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_comment_list_view_family.dart';
import 'package:frontend/community/provider/community_detail_id_provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/component/component_alert_dialog.dart';
import '../../common/const/colors.dart';
import '../../recipe/view/recipe_detail_screen.dart';
import '../component/community_build_tag.dart';
import '../component/community_comment.dart';
import '../component/community_comment_inputbox.dart';
import '../model/community_detail_model.dart';
import '../model/community_tag_position_model.dart';
import '../provider/community_comment_provider.dart';
import '../provider/community_detail_delete_provider.dart';
import '../provider/community_detail_provider.dart';
import '../provider/community_provider.dart';
import '../provider/community_scrap_provider.dart';
import '../provider/community_scrap_status_provider.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String id;

  static String get routeName => 'CommunityDetailScreen';

  const CommunityDetailScreen({super.key, required this.id});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen>
    with WidgetsBindingObserver {
  static const double _horizontalPadding = 16.0;
  static const double _profileImageSize = 32.0;
  static const double _tagImageSize = 85.0;
  static const double _commentInputHeight = 60.0;
  static const double _tagDetailHeight = 90.0;
  static const double _tagContentWidth = 210.0;

  final ScrollController _scrollController = ScrollController();
  final FocusNode _replyFocusNode = FocusNode();

  bool _isShowTag = true;
  int? _parentCommentId;
  String _replyToNickname = '';
  double _previousKeyboardHeight = 0;
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _loadCommunityData();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(communityDetailIdProvider.notifier).setId(widget.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _replyFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (_replyFocusNode.hasFocus) {
      _handleKeyboardVisibilityChange(keyboardHeight);
    }
  }

  void _loadCommunityData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityDetailProvider(widget.id).notifier).fetchData();
    });
  }

  void _activateReplyMode(int parentCommentId, String nickname) {
    setState(() {
      _parentCommentId = parentCommentId;
      _replyToNickname = nickname;
      _isReplying = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _replyFocusNode.requestFocus();
    });
  }

  void _deactivateReplyMode() {
    setState(() {
      _parentCommentId = null;
      _replyToNickname = '';
    });
    _replyFocusNode.unfocus();
  }

  void _toggleTag() {
    setState(() {
      _isShowTag = !_isShowTag;
    });
  }

  void _handleScrapToggle(String postId) async {
    await ref.read(communityScrapProvider).scrap(id: postId);

    ref.read(communityScrapStatusProvider(postId).notifier).toggle();
  }

  void _scrollToCommentSection() {
    const headerHeight = 60.0;
    final imageHeight = MediaQuery.of(context).size.width;
    const tagSectionHeight = _tagDetailHeight + 12;

    final totalHeight = headerHeight + imageHeight + tagSectionHeight;

    _scrollController.animateTo(
      totalHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleKeyboardVisibilityChange(double keyboardHeight) {
    if (_isReplying) {
      _isReplying = false;
      return;
    }

    if (keyboardHeight > _previousKeyboardHeight && keyboardHeight > 100) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCommentSection();
      });
    }
    _previousKeyboardHeight = keyboardHeight;
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityDetailProvider(widget.id));
    final data = communityState.value?.data;
    final scrapStatus = ref.watch(communityScrapStatusProvider(widget.id));

    if (data == null) {
      return const DefaultLayout(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultLayout(
      appBar: _buildAppBar(context),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _buildBottomNavigationBar(context),
      child: _buildContent(data, scrapStatus),
    );
  }

  Widget _buildContent(CommunityDetailModel data, ScrapStatus scrapStatus) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildHeader(data),
        _buildImageSection(data),
        _buildTagSection(data),
        _buildDivider(),
        _buildContentSection(data, scrapStatus),
        _buildDivider(),
        SliverPadding(
          sliver: SliverToBoxAdapter(
            child: Text(
              "community.comments".tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
        ),
        _buildCommentSection(data),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          context.pop();
          ref.invalidate(communityProvider);
        },
        icon: const Icon(Icons.close_outlined),
        tooltip: '닫기',
      ),
      title: Text(
        "community.post".tr(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_parentCommentId != null) _buildReplyIndicator(),
          Container(
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight : 0,
              left: _horizontalPadding,
              right: _horizontalPadding,
            ),
            child: _buildCommentInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: _horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: gray300, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.reply, size: 16, color: gray700),
              const SizedBox(width: 8),
              Text(
                "community.reply_info".tr(
                  namedArgs: {"replyTo": _replyToNickname},
                ),
                style: TextStyle(fontSize: 14, color: gray700),
              ),
            ],
          ),
          IconButton(
            onPressed: _deactivateReplyMode,
            icon: Icon(Icons.close, size: 18, color: gray700),
            tooltip: '답글 취소',
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return SizedBox(
      height: _commentInputHeight,
      child: CommunityCommentInputbox(
        contentWord:
            _parentCommentId != null
                ? "community.reply_hint".tr()
                : "community.comment_hint".tr(),
        commentId: _parentCommentId,
        replyFocusNode: _replyFocusNode,
        id: widget.id,
        onCommentSubmit: _deactivateReplyMode,
      ),
    );
  }

  Widget _buildHeader(CommunityDetailModel data) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: _horizontalPadding,
          top: 8.0,
          bottom: 8.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildProfileImage(data.profileImage),
                const SizedBox(width: 10),
                _buildUserInfo(data),
              ],
            ),
            data.author
                ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // _handleEdit(data);
                } else if (value == 'delete') {
                  final resp = ref.read(communityDetailDeleteProvider).deleteDetail(data.id);
                  resp.then((value) {
                   if (value.statusCode == 200) {
                     if (context.mounted) {
                       componentAlertDialog(title: '삭제되었습니다', context: context);
                       ref.invalidate(communityProvider);
                     }
                   } else {
                     if (context.mounted) {
                       componentAlertDialog(title: '다시 시도해주세요', context: context);
                     }
                   }
                  });
                }
              },
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  height: 48,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 12),
                      Text('수정', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  height: 48,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outlined, size: 18, color: Colors.red[400]),
                      const SizedBox(width: 12),
                      Text('삭제', style: TextStyle(fontSize: 14, color: Colors.red[400])),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String profileImageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child:
          profileImageUrl.isEmpty
              ? const Icon(
                Icons.account_circle_outlined,
                size: _profileImageSize,
              )
              : Image.network(
                profileImageUrl,
                width: _profileImageSize,
                height: _profileImageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.account_circle_outlined,
                    size: _profileImageSize,
                  );
                },
              ),
    );
  }

  Widget _buildUserInfo(CommunityDetailModel data) {
    // 날짜 번역
    final locale = context.locale.toString();
    final formatted = DateFormat.yMMMMd(locale).format(data.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.nickname,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          formatted,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildImageSection(CommunityDetailModel data) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _toggleTag,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),
          ),
          CommunityBuildTag(
            tag: CommunityTagPositionModel(
              x: data.x,
              y: data.y,
              name: data.recipeTag,
              imageUrl: data.recipeImageUrl,
              recipeId: data.id.toString(),
            ),
            isVisible: _isShowTag,
          ),
        ],
      ),
    );
  }

  Widget _buildTagSection(CommunityDetailModel data) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 26,
      ),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: _tagDetailHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (_, index) {
              return _buildTagItem(data);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTagItem(CommunityDetailModel data) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RecipeDetailScreen.routeName,
          pathParameters: {'id': data.recipeId.toString()},
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              data.recipeImageUrl,
              width: _tagImageSize,
              height: _tagImageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: _tagImageSize,
                  height: _tagImageSize,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          SizedBox(
            width: _tagContentWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.recipeTag,
                    style: const TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: const Divider(thickness: 0.5, color: Colors.grey),
      ),
    );
  }

  Widget _buildContentSection(
    CommunityDetailModel data,
    ScrapStatus scrapStatus,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: 26.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContentHeader(data, scrapStatus),
            const SizedBox(height: 10),
            _buildContentBody(data),
          ],
        ),
      ),
    );
  }

  Widget _buildContentHeader(
    CommunityDetailModel data,
    ScrapStatus scrapStatus,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            data.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        _buildInteractionButtons(data, scrapStatus),
      ],
    );
  }

  Widget _buildInteractionButtons(
    CommunityDetailModel data,
    ScrapStatus scrapStatus,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.commentCount.toString(),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4.0),
        const Icon(Icons.comment_outlined, size: 20),
        const SizedBox(width: 8.0),

        Text(
          scrapStatus.scrapCount.toString(),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4.0),

        GestureDetector(
          onTap: () {
            _handleScrapToggle(data.id.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  scrapStatus.scrapped
                      ? "community.fail_scrap".tr()
                      : "community.success_scrap".tr(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: primaryColor,
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Icon(
            scrapStatus.scrapped
                ? Icons.bookmark
                : Icons.bookmark_border_outlined,
            size: 20,
            color: scrapStatus.scrapped ? primaryColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildContentBody(CommunityDetailModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          data.content,
          style: TextStyle(fontSize: 16),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildCommentSection(CommunityDetailModel data) {
    return CommunityCommentListViewFamily(
      itemBuilder: <CommunityCommentModel>(_, index, model) {
        return GestureDetector(
          onLongPress: () {
            _activateReplyMode(model.id, model.nickname);
          },
          child: Container(
            color:
                _parentCommentId == model.id
                    ? Colors.blue.withAlpha(25)
                    : Colors.transparent,
            child: CommunityComment.fromModel(model: model),
          ),
        );
      },
      provider: communityCommentProvider,
      childAspectRatio: 175 / 250,
      id: data.id.toString(),
    );
  }
}
