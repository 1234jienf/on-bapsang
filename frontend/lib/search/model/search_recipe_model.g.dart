// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRecipeModel _$SearchRecipeModelFromJson(Map<String, dynamic> json) =>
    SearchRecipeModel(
      recipe_id: json['recipe_id'] as String,
      name: json['name'] as String,
      ingredients:
          (json['ingredients'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      descriptions: json['description'] as String,
      difficulty: json['difficulty'] as String,
      image_url: json['image_url'] as String,
      material_type: json['material_type'] as String,
      method: json['method'] as String,
      portion: json['portion'] as String,
      review: json['review'] as String,
      time: json['time'] as String,
      scrapped: json['scrapped'] as bool,
    );

Map<String, dynamic> _$SearchRecipeModelToJson(SearchRecipeModel instance) =>
    <String, dynamic>{
      'recipe_id': instance.recipe_id,
      'name': instance.name,
      'ingredients': instance.ingredients,
      'description': instance.descriptions,
      'review': instance.review,
      'time': instance.time,
      'difficulty': instance.difficulty,
      'portion': instance.portion,
      'method': instance.method,
      'material_type': instance.material_type,
      'image_url': instance.image_url,
      'scrapped': instance.scrapped,
    };
