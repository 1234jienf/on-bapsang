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
  imageUrl: json['imageUrl'] as String,
  nickname: json['nickname'] as String,
  createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$CommunityDetailModelToJson(
  CommunityDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'nickname': instance.nickname,
  'content': instance.content,
  'scrapped': instance.scrapped,
  'profileImage': instance.profileImage,
  'x': instance.x,
  'y': instance.y,
  'createdAt': instance.createdAt.toIso8601String(),
};
