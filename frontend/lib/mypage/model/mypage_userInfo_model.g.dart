// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_userInfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MypageUserInfoModel _$MypageUserInfoModelFromJson(Map<String, dynamic> json) =>
    MypageUserInfoModel(
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      nickname: json['nickname'] as String,
      country: json['country'] as String,
      age: (json['age'] as num).toInt(),
      favoriteDishes:
          (json['favoriteDishes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      favoriteTastes:
          (json['favoriteTastes'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      favoriteIngredients:
          (json['favoriteIngredients'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MypageUserInfoModelToJson(
  MypageUserInfoModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'nickname': instance.nickname,
  'country': instance.country,
  'age': instance.age,
  'favoriteDishes': instance.favoriteDishes,
  'favoriteTastes': instance.favoriteTastes,
  'favoriteIngredients': instance.favoriteIngredients,
};
