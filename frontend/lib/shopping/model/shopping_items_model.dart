import 'package:json_annotation/json_annotation.dart';

part 'shopping_items_model.g.dart';

@JsonSerializable()
class ShoppingItemsModel {
  final int cart_item_id;
  final int ingredient_id;
  final String category;
  final String ingredient_name;
  final String image_url;
  final int price;
  final int quantity;
  final int total_price;

  ShoppingItemsModel({
    required this.cart_item_id,
    required this.category,
    required this.image_url,
    required this.ingredient_id,
    required this.ingredient_name,
    required this.price,
    required this.quantity,
    required this.total_price,
  });
  
  factory ShoppingItemsModel.fromJson(Map<String, dynamic> json) => _$ShoppingItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemsModelToJson(this);
}
