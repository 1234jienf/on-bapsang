// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      scrapCount: (json['scrapCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'scrapCount': instance.scrapCount,
      'commentCount': instance.commentCount,
      'nickname': instance.nickname,
      'imageUrl': instance.imageUrl,
    };
