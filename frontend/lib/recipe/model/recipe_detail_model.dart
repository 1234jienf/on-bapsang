import 'package:frontend/common/model/int/model_with_id.dart';

class IngredientModel {
  final int ingredientId;
  final String name;
  final String amount;

  IngredientModel({
    required this.ingredientId,
    required this.name,
    required this.amount,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      ingredientId: int.parse(json['ingredient_id'].toString()),
      name: json['name'],
      amount: json['amount'],
    );
  }
}

class RecipeDetailModel extends IModelWithIntId {
  final String name;
  final List<IngredientModel> ingredients;
  final String descriptions;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String material_type;
  final String image_url;
  final List<String> instruction;
  final bool scrapped;

  RecipeDetailModel({
    required int id,
    required this.name,
    required this.ingredients,
    required this.descriptions,
    required this.review,
    required this.time,
    required this.difficulty,
    required this.portion,
    required this.method,
    required this.material_type,
    required this.image_url,
    required this.instruction,
    required this.scrapped
  }) : super(id: id);

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
    id: int.parse(json['recipe_id'].toString()),
    name: json['name'] ?? '',
    ingredients: (json['ingredients'] as List<dynamic>)
        .map((item) => IngredientModel.fromJson(item))
        .toList(),
    descriptions: json['descriptions'] ?? '',
    review: json['review'] ?? '',
    time: json['time']?.toString() ?? 'unknown',
    difficulty: json['difficulty'] ?? '',
    portion: json['portion'] ?? '',
    method: json['method'] ?? '',
    material_type: json['material_type'] ?? '',
    image_url: json['image_url'] ?? '',
    instruction: (json['instruction'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    scrapped: json['scrapped'] ?? false,
   );
  }
}
