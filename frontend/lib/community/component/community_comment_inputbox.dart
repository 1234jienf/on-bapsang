import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/community_comment_upload_provider.dart';
import '../provider/community_detail_provider.dart';
import 'community_show_dialog.dart';

class CommunityCommentInputbox extends ConsumerStatefulWidget {
  final String id;
  final int? commentId;
  final String contentWord;
  final FocusNode? replyFocusNode;
  final VoidCallback? onCommentSubmit;

  const CommunityCommentInputbox({
    super.key,
    required this.id,
    required this.commentId,
    required this.contentWord,
    this.replyFocusNode,
    this.onCommentSubmit,
  });

  @override
  ConsumerState<CommunityCommentInputbox> createState() =>
      _ConsumerCommunityCommentInputboxState();
}

class _ConsumerCommunityCommentInputboxState
    extends ConsumerState<CommunityCommentInputbox> {
  late final TextEditingController controller;
  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = ref.watch(communityCommentUploadProvider);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: widget.replyFocusNode,
            controller: controller,
            onFieldSubmitted:
                (value) => {
                  __comment(
                    commentProvider,
                    widget.id,
                    controller.text,
                    widget.commentId,
                  ),
                },
            minLines: 1,
            maxLines: 2,
            maxLength: 50,

            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              hintText: widget.contentWord,
              hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              filled: true,
              isCollapsed: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              counterText: '',
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            if (controller.text.trim().isNotEmpty) {
              __comment(
                commentProvider,
                widget.id,
                controller.text,
                widget.commentId,
              );
            }
          },
          child: Icon(Icons.send),
        ),
      ],
    );
  }

  Future<void> __comment(
    CommunityCommentUploadModel commentProvider,
    String id,
    String text,
    int? parentId,
  ) async {
    if (text.isEmpty || isSubmit) return;

    isSubmit = true;

    try {
      final response = await commentProvider.uploadCommentPost(
        id: id,
        content: text,
        parentId: parentId,
      );

      if (mounted) {
        controller.clear();
        if (response.statusCode == 200) {
          FocusScope.of(context).unfocus();

          if (widget.onCommentSubmit != null) {
            widget.onCommentSubmit!();
          }

          if (context.mounted) {
            communityShowDialog(context, ref, false, '작성 성공!');
          }
          ref.read(communityDetailProvider(widget.id).notifier).fetchData();
          isSubmit = false;
        } else {
          if (context.mounted) {
            communityShowDialog(context, ref, false, '오류가 발생했습니다. 다시 시도해주세요');
          }
          isSubmit = false;
        }
      }
    } on DioException {
      rethrow;
    } finally {
      isSubmit = false;
    }
  }
}
