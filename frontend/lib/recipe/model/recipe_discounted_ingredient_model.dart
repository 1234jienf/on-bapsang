class DiscountedIngredient {
  final String ingredient;
  final int originalPrice;
  final int ingredientId;
  final String materialType;
  final String discountRate;
  final int salePrice;
  final String imageUrl;

  DiscountedIngredient({
    required this.ingredient,
    required this.originalPrice,
    required this.ingredientId,
    required this.materialType,
    required this.discountRate,
    required this.salePrice,
    required this.imageUrl,
  });

  factory DiscountedIngredient.fromJson(Map<String, dynamic> json) {
    return DiscountedIngredient(
      ingredient: json['ingredient'],
      originalPrice: json['original_price'],
      ingredientId: json['ingredient_id'],
      materialType: json['material_type'],
      discountRate: json['discount_rate'],
      salePrice: json['sale_price'],
      imageUrl: json['image_url'],
    );
  }

  DiscountedIngredient copyWith({
    String? ingredientName,
  }) =>
      DiscountedIngredient(
        ingredientId:    ingredientId,
        originalPrice:   originalPrice,
        salePrice:       salePrice,
        discountRate:    discountRate,
        materialType:    materialType,
        imageUrl:        imageUrl,
        ingredient:  ingredientName ?? this.ingredient,
      );

}