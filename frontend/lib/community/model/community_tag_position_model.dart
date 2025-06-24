
import 'package:json_annotation/json_annotation.dart';

part 'community_tag_position_model.g.dart';

@JsonSerializable()
class CommunityTagPositionModel {
  final double x;
  final double y;
  final String name;
  final String imageUrl;
  final String recipeId;

  CommunityTagPositionModel({
    required this.x,
    required this.y,
    required this.name,
    required this.imageUrl,
    required this.recipeId,
  });

  factory CommunityTagPositionModel.fromJson(Map<String, dynamic> json) => _$CommunityTagPositionModelFromJson(json);

}