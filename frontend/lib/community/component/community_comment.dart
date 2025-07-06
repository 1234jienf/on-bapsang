import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/component/component_alert_dialog.dart';
import 'package:frontend/community/model/community_comment_model.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/colors.dart';
import '../provider/community_comment_delete_provider.dart';
import '../provider/community_detail_id_provider.dart';
import '../provider/community_detail_provider.dart';

class CommunityComment extends ConsumerWidget {
  final int id;
  final String content;
  final String nickname;
  final String? profileImage;
  final DateTime createdAt;
  final List<dynamic> children;
  final bool author;

  const CommunityComment({
    super.key,
    required this.content,
    required this.children,
    required this.nickname,
    required this.createdAt,
    required this.profileImage,
    required this.id,
    required this.author,
  });

  factory CommunityComment.fromModel({required CommunityCommentModel model}) {
    return CommunityComment(
      content: model.content,
      children: model.children,
      nickname: model.nickname,
      createdAt: model.createdAt,
      profileImage: model.profileImage,
      id: model.id,
      author: model.author,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        children: [
          Row(
            children: [
              profileImage == null
                  ? Icon(Icons.account_circle_outlined, size: 32)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  profileImage!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nickname, style: TextStyle(fontSize: 12)),
                  Text(
                    DateFormat('yy년 M월 d일').format(createdAt),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: SizedBox(
                  height: 32,
                  child: Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              author
                  ? GestureDetector(
                onTap: () {
                  final resp = ref
                      .read(communityCommentDeleteProvider)
                      .deleteComment(id);
                  resp.then((res) {
                    if (res.statusCode == 200) {
                      if (context.mounted) {
                        componentAlertDialog(title: '삭제되었습니다', context: context);
                      }
                      final id = ref.watch(communityDetailIdProvider);
                      ref.read(communityDetailProvider(id).notifier).fetchData();
                    }
                  });
                },
                child: Icon(Icons.close_outlined),
              )
                  : SizedBox(),
            ],
          ),
          if (children.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...children.map((reply) => _childrenComments(context, reply, ref)),
          ],
        ],
      ),
    );
  }

  // 대댓글
  Widget _childrenComments(BuildContext context, CommunityCommentModel reply,
      WidgetRef ref) {
    // 날짜 번역
    final locale = context.locale.toString();
    final formatted = DateFormat.yMMMMd(locale).format(createdAt);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.subdirectory_arrow_right_outlined),
          const SizedBox(width: 10.0),
          reply.profileImage == null
              ? Icon(
            Icons.account_circle_outlined,
            size: 32,
            color: Colors.grey[400],
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              reply.profileImage!,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.nickname,
                      style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formatted,
                      // DateFormat('yy년 M월 d일').format(reply.createdAt),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(width: 16.0),

                Expanded(
                  child: Text(
                    reply.content,
                    style: TextStyle(fontSize: 12, color: gray900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                reply.author
                    ? GestureDetector(
                  onTap: () {
                    final resp = ref
                        .read(communityCommentDeleteProvider)
                        .deleteComment(id);
                    resp.then((res) {
                      if (res.statusCode == 200) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Timer(Duration(milliseconds: 800), () {
                                if (context.mounted) {
                                  context.pop();
                                }
                              });
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '댓글이 삭제되었습니다',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        final id = ref.watch(communityDetailIdProvider);
                        ref.read(communityDetailProvider(id).notifier).fetchData();
                      }
                    });
                    },
                  child: Icon(Icons.close_outlined),
                )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
