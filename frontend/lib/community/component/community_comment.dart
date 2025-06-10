import 'package:flutter/material.dart';
import 'package:frontend/community/model/community_comment_model.dart';
import 'package:intl/intl.dart';

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
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileImage == null
                  ? Icon(Icons.account_circle_outlined, size: 32)
                  : Image.network(
                    profileImage!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nickname, style: TextStyle(fontSize: 14)),
                  Text(
                    DateFormat('yy년 M월 d일').format(createdAt),
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
                          content,
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
        );
  }
}
