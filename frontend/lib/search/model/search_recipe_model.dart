import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_recipe_model.g.dart';

@JsonSerializable()
class SearchRecipeModel implements IModelWithStringId {
  @override
  final String recipe_id;
  final String name;
  final List<String> ingredients;
  final String descriptions;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String material_type;
  final String image_url;

  SearchRecipeModel({
    required this.recipe_id,
    required this.name,
    required this.ingredients,
    required this.descriptions,
    required this.difficulty,
    required this.image_url,
    required this.material_type,
    required this.method,
    required this.portion,
    required this.review,
    required this.time,
  });

  factory SearchRecipeModel.fromJson(Map<String, dynamic> json) =>
      _$SearchRecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRecipeModelToJson(this);
}
