
import 'package:json_annotation/json_annotation.dart';

part 'post_shopping_cart_model.g.dart';

@JsonSerializable()
class PostShoppingCartModel {
  final int ingredient_id;
  final int quantity;

  PostShoppingCartModel({
    required this.quantity,
    required this.ingredient_id,
  });

  factory PostShoppingCartModel.fromJson(Map<String, dynamic> json) => _$PostShoppingCartModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostShoppingCartModelToJson(this);
}