// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  nickname: json['nickname'] as String,
  country: json['country'] as String,
  age: (json['age'] as num).toInt(),
  location: json['location'] as String,
  favoriteTastes: (json['favoriteTastes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  favoriteDishes: (json['favoriteDishes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  favoriteIngredients: (json['favoriteIngredients'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'nickname': instance.nickname,
  'country': instance.country,
  'age': instance.age,
  'location': instance.location,
  'favoriteTastes': instance.favoriteTastes,
  'favoriteDishes': instance.favoriteDishes,
  'favoriteIngredients': instance.favoriteIngredients,
};
