// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      title: json['title'] as String,
      id: (json['id'] as num).toInt(),
      imageUrl: DataUtils.pathToUrl(json['imageUrl'] as String),
      scrapCount: (json['scrapCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      nickname: json['nickname'] as String,
      createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'scrapCount': instance.scrapCount,
      'commentCount': instance.commentCount,
      'nickname': instance.nickname,
    };
