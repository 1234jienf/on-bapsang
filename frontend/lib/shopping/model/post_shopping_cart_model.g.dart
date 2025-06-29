// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_shopping_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostShoppingCartModel _$PostShoppingCartModelFromJson(
  Map<String, dynamic> json,
) => PostShoppingCartModel(
  quantity: (json['quantity'] as num).toInt(),
  ingredient_id: (json['ingredient_id'] as num).toInt(),
);

Map<String, dynamic> _$PostShoppingCartModelToJson(
  PostShoppingCartModel instance,
) => <String, dynamic>{
  'ingredient_id': instance.ingredient_id,
  'quantity': instance.quantity,
};
