import 'package:json_annotation/json_annotation.dart';

part 'community_upload_data_model.g.dart';

@JsonSerializable()
class CommunityUploadDataModel {
  final String title;
  final String content;
  final String recipeTag;
  final String recipeId;
  final double x;
  final double y;

  CommunityUploadDataModel({
    required this.content,
    required this.title,
    required this.recipeId,
    required this.recipeTag,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => _$CommunityUploadDataModelToJson(this);
}