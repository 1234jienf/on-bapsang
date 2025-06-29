// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_get_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingCartGetModel _$ShoppingCartGetModelFromJson(
  Map<String, dynamic> json,
) => ShoppingCartGetModel(
  total_price: (json['total_price'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>)
          .map((e) => ShoppingItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ShoppingCartGetModelToJson(
  ShoppingCartGetModel instance,
) => <String, dynamic>{
  'total_price': instance.total_price,
  'items': instance.items,
};
