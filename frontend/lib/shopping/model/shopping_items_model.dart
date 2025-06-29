import 'package:json_annotation/json_annotation.dart';

part 'shopping_items_model.g.dart';

@JsonSerializable()
class ShoppingItemsModel {
  final int cartItemId;
  final int ingredientId;
  final String category;
  final String ingredientName;
  final String imageUrl;
  final int price;
  late final int quantity;
  final int totalPrice;

  ShoppingItemsModel({
    required this.cartItemId,
    required this.category,
    required this.ingredientId,
    required this.ingredientName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  ShoppingItemsModel copyWith({
    int? cartItemId,
    int? ingredientId,
    String? category,
    String? ingredientName,
    String? imageUrl,
    int? price,
    int? quantity,
    int? totalPrice,
  }) {
    return ShoppingItemsModel(
      cartItemId: cartItemId ?? this.cartItemId,
      ingredientId: ingredientId ?? this.ingredientId,
      category: category ?? this.category,
      ingredientName: ingredientName ?? this.ingredientName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
  
  factory ShoppingItemsModel.fromJson(Map<String, dynamic> json) => _$ShoppingItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemsModelToJson(this);
}
