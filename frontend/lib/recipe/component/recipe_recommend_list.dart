import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/recipe/component/recipe_card.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';

// 인기 레시피 목록
class RecipeRecommendList extends ConsumerStatefulWidget {
  const RecipeRecommendList({super.key});

  @override
  ConsumerState<RecipeRecommendList> createState() => _RecipeRecommendListState();
}

class _RecipeRecommendListState extends ConsumerState<RecipeRecommendList> {
  @override
  Widget build(BuildContext context) {
    final recommendRecipeAsync = ref.watch(recommendRecipesProvider);

    return recommendRecipeAsync.when(
      loading: () => SizedBox(
        height: 50.0,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 50.0,
        child: Center(child: Text('$err')),
      ),
      data: (List<RecipeModel> recipes) {
        if (recipes.isEmpty) {
          return SizedBox(
            height: 200.0,
            child: Center(child: Text('추천레시피가 없습니다.')),
          );
        }
        return RecipeCard(recipes: recipes);
      },
    );
  }
}
