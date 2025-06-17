import 'package:json_annotation/json_annotation.dart';

part 'community_upload_recipe_list_model.g.dart';

@JsonSerializable()
class CommunityUploadRecipeListModel {
  final String recipeId;
  final String name;
  final String imageUrl;

  CommunityUploadRecipeListModel({
    required this.recipeId,
    required this.name,
    required this.imageUrl,
  });

  factory CommunityUploadRecipeListModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityUploadRecipeListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityUploadRecipeListModelToJson(this);
}
