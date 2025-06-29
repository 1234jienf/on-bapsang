// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItemsModel _$ShoppingItemsModelFromJson(Map<String, dynamic> json) =>
    ShoppingItemsModel(
      cartItemId: (json['cartItemId'] as num).toInt(),
      category: json['category'] as String,
      ingredientId: (json['ingredientId'] as num).toInt(),
      ingredientName: json['ingredientName'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toInt(),
    );

Map<String, dynamic> _$ShoppingItemsModelToJson(ShoppingItemsModel instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'ingredientId': instance.ingredientId,
      'category': instance.category,
      'ingredientName': instance.ingredientName,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
    };
