import 'package:frontend/shopping/model/shopping_items_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_cart_get_model.g.dart';

@JsonSerializable()
class ShoppingCartGetModel {
  final int total_price;
  final List<ShoppingItemsModel> items;

  ShoppingCartGetModel({required this.total_price, required this.items});

  ShoppingCartGetModel copyWith({
    int? total_price,
    List<ShoppingItemsModel>? items,
  }) {
    return ShoppingCartGetModel(
      total_price: total_price ?? this.total_price,
      items: items ?? this.items,
    );
  }


  factory ShoppingCartGetModel.fromJson(Map<String, dynamic> json) => _$ShoppingCartGetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingCartGetModelToJson(this);
}