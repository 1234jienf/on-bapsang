// ignore_for_file: non_constant_identifier_names

import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_recipe_model.g.dart';

@JsonSerializable()
class SearchRecipeModel implements IModelWithStringId {
  @override
  final String recipe_id;
  final String name;
  final List<String> ingredients;
  @JsonKey(name: 'description')
  final String descriptions;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String material_type;
  final String image_url;
  final bool scrapped;

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
    required this.scrapped
  });

  factory SearchRecipeModel.fromJson(Map<String, dynamic> json) {
    return SearchRecipeModel(
      recipe_id: json['recipe_id'] as String,
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List).map((e) => e as String).toList(),
      descriptions: json['descriptions'] ?? json['description'] ?? '',
      review: json['review'] as String,
      time: json['time'] as String,
      difficulty: json['difficulty'] as String,
      portion: json['portion'] as String,
      method: json['method'] as String,
      material_type: json['material_type'] as String,
      image_url: json['image_url'] as String,
      scrapped: json['scrapped'] as bool,
    );
  }

  Map<String, dynamic> toJson() => _$SearchRecipeModelToJson(this);
}
