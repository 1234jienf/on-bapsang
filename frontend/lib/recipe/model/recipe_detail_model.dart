import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:frontend/common/utils/data_uitls.dart';

// 재료 정보 모델
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

// 레시피 후기
class RecipeReviewModel {
  final int id;
  final String title;
  final String imageUrl;
  final int scrapCount;
  final int commentCount;
  final DateTime createdAt;
  final String nickname;
  final double x;
  final double y;

  RecipeReviewModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.scrapCount,
    required this.commentCount,
    required this.createdAt,
    required this.nickname,
    required this.x,
    required this.y
  });

  factory RecipeReviewModel.fromJson(Map<String, dynamic> json) {
    return RecipeReviewModel(
      id: int.parse(json['id'].toString()),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      scrapCount: (json['scrapCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      createdAt: DataUtils.dateTimeFromJson(json['createdAt'] as String),
      nickname: json['nickname'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}


// 레시피 상세
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
  final List<RecipeReviewModel> reviews;
  final int reviewCount;

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
    required this.scrapped,
    required this.reviews,
    required this.reviewCount
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
    reviews: (json['reviews'] as List<dynamic>)
        .map((item) => RecipeReviewModel.fromJson(item))
        .toList(),
    reviewCount: json['reviewCount'],
   );
  }
}
