// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityDetailModel _$CommunityDetailModelFromJson(
  Map<String, dynamic> json,
) => CommunityDetailModel(
  content: json['content'] as String,
  scrapped: json['scrapped'] as bool,
  profileImage: json['profileImage'] as String?,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  imageUrl: DataUtils.pathToUrl(json['imageUrl'] as String),
  nickname: json['nickname'] as String,
  scrapCount: (json['scrapCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$CommunityDetailModelToJson(
  CommunityDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'title': instance.title,
  'scrapCount': instance.scrapCount,
  'commentCount': instance.commentCount,
  'nickname': instance.nickname,
  'content': instance.content,
  'scrapped': instance.scrapped,
  'profileImage': instance.profileImage,
  'x': instance.x,
  'y': instance.y,
};
