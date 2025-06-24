// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityDetailModel _$CommunityDetailModelFromJson(
  Map<String, dynamic> json,
) => CommunityDetailModel(
  recipeTag: json['recipeTag'] as String,
  recipeImageUrl: json['recipeImageUrl'] as String,
  scrapped: json['scrapped'] as bool,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  scrapCount: (json['scrapCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  imageUrl: json['imageUrl'] as String,
  nickname: json['nickname'] as String,
  content: json['content'] as String,
  profileImage: json['profileImage'] as String,
);

Map<String, dynamic> _$CommunityDetailModelToJson(
  CommunityDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'nickname': instance.nickname,
  'content': instance.content,
  'profileImage': instance.profileImage,
  'scrapped': instance.scrapped,
  'scrapCount': instance.scrapCount,
  'commentCount': instance.commentCount,
  'x': instance.x,
  'y': instance.y,
  'recipeImageUrl': instance.recipeImageUrl,
  'recipeTag': instance.recipeTag,
  'createdAt': instance.createdAt.toIso8601String(),
};
