import 'package:flutter/material.dart';
import 'package:frontend/community/model/community_comment_model.dart';
import 'package:intl/intl.dart';

import '../../common/const/colors.dart';

class CommunityComment extends StatelessWidget {
  final int id;
  final String content;
  final String nickname;
  final String? profileImage;
  final DateTime createdAt;
  final List<dynamic> children;

  const CommunityComment({
    super.key,
    required this.content,
    required this.children,
    required this.nickname,
    required this.createdAt,
    required this.profileImage,
    required this.id,
  });

  factory CommunityComment.fromModel({required CommunityCommentModel model}) {
    return CommunityComment(
      content: model.content,
      children: model.children,
      nickname: model.nickname,
      createdAt: model.createdAt,
      profileImage: model.profileImage,
      id: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
            ],
          ),
          if (children.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...children.map((reply) => _childrenComments(reply)),
          ],
        ],
      ),
    );
  }

  // 대댓글
  Widget _childrenComments(CommunityCommentModel reply) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      DateFormat('yy년 M월 d일').format(reply.createdAt),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
