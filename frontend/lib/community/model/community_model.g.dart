// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      title: json['title'] as String,
      intId: (json['intId'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: DataUtils.pathToUrl(json['imageUrl'] as String),
      scrapCount: (json['scrapCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      nickname: json['nickname'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'intId': instance.intId,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'name': instance.name,
      'scrapCount': instance.scrapCount,
      'commentCount': instance.commentCount,
      'nickname': instance.nickname,
      'createdAt': instance.createdAt,
    };
