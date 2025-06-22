import 'package:frontend/common/model/int/model_with_id.dart';

class RecipeModel extends IModelWithIntId {
  final String name;
  final List<String> ingredients;
  final String description;
  final String review;
  final String time;
  final String difficulty;
  final String portion;
  final String method;
  final String materialType;
  final String imageUrl;
  final bool scrapped;

  RecipeModel({
    required int id,
    required this.name,
    required this.ingredients,
    required this.description,
    required this.review,
    required this.time,
    required this.difficulty,
    required this.portion,
    required this.method,
    required this.materialType,
    required this.imageUrl,
    required this.scrapped,
  }) : super(id: id);

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: int.parse(json['recipe_id'].toString()),
      name: json['name'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      description: json['description'] ?? '',
      review: json['review'] ?? '',
      time: json['time']?.toString() == 'NaN' ? '-' : json['time']?.toString() ?? '-',
      difficulty: json['difficulty'] ?? '',
      portion: json['portion'] ?? '',
      method: json['method'] ?? '',
      materialType: json['material_type'] ?? '',
      imageUrl: json['image_url'] ?? '',
      scrapped: json['scrapped'] ?? false,
    );
  }

  RecipeModel copyWith({
    int? id,
    String? name,
    List<String>? ingredients,
    String? description,
    String? review,
    String? time,
    String? difficulty,
    String? portion,
    String? method,
    String? materialType,
    String? imageUrl,
    bool? scrapped,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      description: description ?? this.description,
      review: review ?? this.review,
      time: time ?? this.time,
      difficulty: difficulty ?? this.difficulty,
      portion: portion ?? this.portion,
      method: method ?? this.method,
      materialType: materialType ?? this.materialType,
      imageUrl: imageUrl ?? this.imageUrl,
      scrapped: scrapped ?? this.scrapped,
    );
  }
}
