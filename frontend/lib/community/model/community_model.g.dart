// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      title: json['title'] as String,
      id: (json['id'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      nickname: json['nickname'] as String,
      content: json['content'] as String,
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'nickname': instance.nickname,
      'content': instance.content,
      'profileImage': instance.profileImage,
    };
