// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingDetailModel _$ShoppingDetailModelFromJson(
  Map<String, dynamic> json,
) => ShoppingDetailModel(
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
  shoppingIngredientInfo: ShoppingIngredientInfo.fromJson(
    json['ingredient_info'] as Map<String, dynamic>,
  ),
  shoppingRelatedRecipe:
      (json['related_recipes'] as List<dynamic>)
          .map((e) => ShoppingRelatedRecipe.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ShoppingDetailModelToJson(
  ShoppingDetailModel instance,
) => <String, dynamic>{
  'meta': instance.meta,
  'ingredient_info': instance.shoppingIngredientInfo,
  'related_recipes': instance.shoppingRelatedRecipe,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  currentPage: (json['currentPage'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'hasMore': instance.hasMore,
};

ShoppingIngredientInfo _$ShoppingIngredientInfoFromJson(
  Map<String, dynamic> json,
) => ShoppingIngredientInfo(
  category: json['category'] as String,
  image_url: json['image_url'] as String,
  ingredient_id: (json['ingredient_id'] as num).toInt(),
  name: json['name'] as String,
  price: json['price'] as String,
  unit: json['unit'] as String,
);

Map<String, dynamic> _$ShoppingIngredientInfoToJson(
  ShoppingIngredientInfo instance,
) => <String, dynamic>{
  'ingredient_id': instance.ingredient_id,
  'name': instance.name,
  'image_url': instance.image_url,
  'category': instance.category,
  'price': instance.price,
  'unit': instance.unit,
};

ShoppingRelatedRecipe _$ShoppingRelatedRecipeFromJson(
  Map<String, dynamic> json,
) => ShoppingRelatedRecipe(
  recipe_id: json['recipe_id'] as String,
  name: json['name'] as String,
  ingredients:
      (json['ingredients'] as List<dynamic>).map((e) => e as String).toList(),
  description: json['description'] as String,
  review: json['review'] as String,
  time: json['time'] as String,
  difficulty: json['difficulty'] as String,
  portion: json['portion'] as String,
  method: json['method'] as String,
  material_type: json['material_type'] as String,
  image_url: json['image_url'] as String,
  scrapped: json['scrapped'] as bool,
);

Map<String, dynamic> _$ShoppingRelatedRecipeToJson(
  ShoppingRelatedRecipe instance,
) => <String, dynamic>{
  'recipe_id': instance.recipe_id,
  'name': instance.name,
  'ingredients': instance.ingredients,
  'description': instance.description,
  'review': instance.review,
  'time': instance.time,
  'difficulty': instance.difficulty,
  'portion': instance.portion,
  'method': instance.method,
  'material_type': instance.material_type,
  'image_url': instance.image_url,
  'scrapped': instance.scrapped,
};
