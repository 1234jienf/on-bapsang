class IngredientItemModel {
  final String ingredient;
  final int originalPrice;
  final int ingredientId;
  final String materialType;
  final String discountRate;
  final int salePrice;
  final String imageUrl;

  IngredientItemModel({
    required this.ingredient,
    required this.originalPrice,
    required this.ingredientId,
    required this.materialType,
    required this.discountRate,
    required this.salePrice,
    required this.imageUrl,
  });

  factory IngredientItemModel.fromJson(Map<String, dynamic> json) {
    return IngredientItemModel(
      ingredient: json['ingredient'],
      originalPrice: json['original_price'],
      ingredientId: json['ingredient_id'],
      materialType: json['material_type'],
      discountRate: json['discount_rate'],
      salePrice: json['sale_price'],
      imageUrl: json['image_url'],
    );
  }

  IngredientItemModel copyWith({
    String? ingredientName,
  }) =>
      IngredientItemModel(
        ingredientId:    ingredientId,
        originalPrice:   originalPrice,
        salePrice:       salePrice,
        discountRate:    discountRate,
        materialType:    materialType,
        imageUrl:        imageUrl,
        ingredient:  ingredientName ?? this.ingredient,
      );

}