import 'package:flutter/material.dart';

import '../../model/search_recipe_model.dart';

class SearchRecipeCard extends StatelessWidget {
  final String recipe_id;
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

  const SearchRecipeCard({
    super.key,
    required this.recipe_id,
    required this.name,
    required this.ingredients,
    required this.descriptions,
    required this.difficulty,
    required this.image_url,
    required this.material_type,
    required this.method,
    required this.portion,
    required this.review,
    required this.time,
  });

  factory SearchRecipeCard.fromModel({required SearchRecipeModel model}) {
    return SearchRecipeCard(
      recipe_id: model.recipe_id,
      review: model.review,
      name: model.name,
      descriptions: model.descriptions,
      difficulty: model.difficulty,
      image_url: model.image_url,
      material_type: model.material_type,
      method: model.method,
      portion: model.portion,
      time: model.time,
      ingredients: model.ingredients,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
        height: 100.0,
        child: Row(
          children: [
            ClipRRect(
              child: Image.network(
                image_url,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: SizedBox(
                width: 210.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Text(portion, style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 8.0),
                        Text(method, style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 8.0),
                        Text(time, style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 8.0),
                        Text(difficulty, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Image.asset('asset/img/kid_star.png'),
                        const SizedBox(width: 6.0),
                        Text('4.5', style: TextStyle(fontSize: 12.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Icon(Icons.bookmark_border_outlined, size: 22.0),
          ],
        ),
      ),
    );
  }
}
