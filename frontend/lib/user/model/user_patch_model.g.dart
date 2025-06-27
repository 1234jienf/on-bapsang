// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_patch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPatchModel _$UserPatchModelFromJson(Map<String, dynamic> json) =>
    UserPatchModel(
      nickname: json['nickname'] as String?,
      age: (json['age'] as num?)?.toInt(),
      favoriteTasteIds:
          (json['favoriteTasteIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      favoriteDishIds:
          (json['favoriteDishIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
      favoriteIngredientIds:
          (json['favoriteIngredientIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList(),
    );

Map<String, dynamic> _$UserPatchModelToJson(UserPatchModel instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'age': instance.age,
      'favoriteTasteIds': instance.favoriteTasteIds,
      'favoriteDishIds': instance.favoriteDishIds,
      'favoriteIngredientIds': instance.favoriteIngredientIds,
    };
