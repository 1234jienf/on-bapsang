import 'package:json_annotation/json_annotation.dart';

part 'shopping_detail_model.g.dart';

@JsonSerializable()
class ShoppingDetailModel {
  final Meta meta;
  @JsonKey(name: 'ingredient_info')
  final ShoppingIngredientInfo shoppingIngredientInfo;
  @JsonKey(name: 'related_recipes')
  final List<ShoppingRelatedRecipe> shoppingRelatedRecipe;

  ShoppingDetailModel({required this.meta, required this.shoppingIngredientInfo, required this.shoppingRelatedRecipe});

  factory ShoppingDetailModel.fromJson(Map<String, dynamic> json) => _$ShoppingDetailModelFromJson(json);

}

@JsonSerializable()
class Meta {
  final int currentPage;
  final bool hasMore;

  Meta({required this.currentPage, required this.hasMore});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@JsonSerializable()
class ShoppingIngredientInfo {
  final int ingredient_id;
  final String name;
  final String image_url;
  final String category;
  final String price;
  final String unit;
  
  ShoppingIngredientInfo({required this.category, required this.image_url, required this.ingredient_id, required this.name, required this.price, required this.unit});
  
  factory ShoppingIngredientInfo.fromJson(Map<String, dynamic> json) => _$ShoppingIngredientInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingIngredientInfoToJson(this);
}

@JsonSerializable()
class ShoppingRelatedRecipe {
  final String recipe_id;
  final String name;
  final List<String> ingredients;
  final String description;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String material_type;
  final String image_url;
  final bool scrapped;

  ShoppingRelatedRecipe({
    required this.recipe_id,
    required this.name,
    required this.ingredients,
    required this.description,
    required this.review,
    required this.time,
    required this.difficulty,
    required this.portion,
    required this.method,
    required this.material_type,
    required this.image_url,
    required this.scrapped,
  });

  factory ShoppingRelatedRecipe.fromJson(Map<String, dynamic> json) =>
      _$ShoppingRelatedRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingRelatedRecipeToJson(this);
}
