class DiscountedIngredient {
  final String ingredient;
  final int originalPrice;
  final String discountRate;
  final int salePrice;
  final String imageUrl;

  DiscountedIngredient({
    required this.ingredient,
    required this.originalPrice,
    required this.discountRate,
    required this.salePrice,
    required this.imageUrl,
  });

  factory DiscountedIngredient.fromJson(Map<String, dynamic> json) {
    return DiscountedIngredient(
      ingredient: json['ingredient'],
      originalPrice: json['original_price'],
      discountRate: json['discount_rate'],
      salePrice: json['sale_price'],
      imageUrl: json['image_url'],
    );
  }
}