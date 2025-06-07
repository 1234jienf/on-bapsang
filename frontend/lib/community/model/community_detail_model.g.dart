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
  intId: (json['intId'] as num).toInt(),
  title: json['title'] as String,
  imageUrl: DataUtils.pathToUrl(json['imageUrl'] as String),
  nickname: json['nickname'] as String,
  scrapCount: (json['scrapCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$CommunityDetailModelToJson(
  CommunityDetailModel instance,
) => <String, dynamic>{
  'intId': instance.intId,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'name': instance.name,
  'scrapCount': instance.scrapCount,
  'commentCount': instance.commentCount,
  'nickname': instance.nickname,
  'createdAt': instance.createdAt,
  'content': instance.content,
  'scrapped': instance.scrapped,
  'profileImage': instance.profileImage,
  'x': instance.x,
  'y': instance.y,
};
