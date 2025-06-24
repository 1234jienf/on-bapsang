// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MypageCommunityModel _$MypageCommunityModelFromJson(
  Map<String, dynamic> json,
) => MypageCommunityModel(
  title: json['title'] as String,
  id: (json['postId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  nickname: json['nickname'] as String,
  content: json['content'] as String,
  profileImage: json['profileImage'] as String,
);

Map<String, dynamic> _$MypageCommunityModelToJson(
  MypageCommunityModel instance,
) => <String, dynamic>{
  'postId': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'nickname': instance.nickname,
  'content': instance.content,
  'profileImage': instance.profileImage,
};
