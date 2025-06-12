class RecipeDetailModel {
  final int recipe_id;
  final String name;
  final List<String> ingredients;
  final String descriptions;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String material_type;
  final String image_url;

  RecipeDetailModel({
    required this.recipe_id,
    required this.name,
    required this.ingredients,
    required this.descriptions,
    required this.review,
    required this.time,
    required this.difficulty,
    required this.portion,
    required this.method,
    required this.material_type,
    required this.image_url
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      recipe_id: int.parse(json['recipe_id'].toString()),
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      descriptions: json['descriptions'],
      review: json['review'],
      time: json['time'],
      difficulty: json['difficulty'],
      portion: json['portion'],
      method: json['method'],
      material_type: json['material_type'],
      image_url: json['image_url'],
    );
  }
}