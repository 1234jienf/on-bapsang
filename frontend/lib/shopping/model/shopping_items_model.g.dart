// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItemsModel _$ShoppingItemsModelFromJson(Map<String, dynamic> json) =>
    ShoppingItemsModel(
      cart_item_id: (json['cart_item_id'] as num).toInt(),
      category: json['category'] as String,
      image_url: json['image_url'] as String,
      ingredient_id: (json['ingredient_id'] as num).toInt(),
      ingredient_name: json['ingredient_name'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      total_price: (json['total_price'] as num).toInt(),
    );

Map<String, dynamic> _$ShoppingItemsModelToJson(ShoppingItemsModel instance) =>
    <String, dynamic>{
      'cart_item_id': instance.cart_item_id,
      'ingredient_id': instance.ingredient_id,
      'category': instance.category,
      'ingredient_name': instance.ingredient_name,
      'image_url': instance.image_url,
      'price': instance.price,
      'quantity': instance.quantity,
      'total_price': instance.total_price,
    };
