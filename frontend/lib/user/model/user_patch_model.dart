import 'package:json_annotation/json_annotation.dart';

part 'user_patch_model.g.dart';

@JsonSerializable()
class UserPatchModel {
  final String? nickname;
  final int? age;
  final List<int>? favoriteTasteIds;
  final List<int>? favoriteDishIds;
  final List<int>? favoriteIngredientIds;

  UserPatchModel({
    this.nickname,
    this.age,
    this.favoriteTasteIds,
    this.favoriteDishIds,
    this.favoriteIngredientIds,
  });

  factory UserPatchModel.fromJson(Map<String, dynamic> json)
    => _$UserPatchModelFromJson(json);
    Map<String, dynamic> toJson() => _$UserPatchModelToJson(this);
}