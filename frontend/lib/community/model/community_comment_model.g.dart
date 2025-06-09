// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityCommentModel _$CommunityCommentModelFromJson(
  Map<String, dynamic> json,
) => CommunityCommentModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  profileImage: json['profileImage'] as String,
  createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
  nickname: json['nickname'] as String,
  children: json['children'] as List<dynamic>,
);

