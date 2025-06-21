import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/recipe/component/recipe_card.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';

// 인기 레시피 목록
class RecipePopularList extends ConsumerStatefulWidget {
  const RecipePopularList({super.key});

  @override
  ConsumerState<RecipePopularList> createState() => _RecipePopularListState();
}

class _RecipePopularListState extends ConsumerState<RecipePopularList> {
  @override
  Widget build(BuildContext context) {
    final popularRecipeAsync = ref.watch(popularRecipesProvider);

    return popularRecipeAsync.when(
      loading: () => Container(
        height: 50.0,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Container(
        height: 50.0,
        child: Center(child: Text('$err')),
      ),
      data: (List<RecipeModel> recipes) {
        if (recipes.isEmpty) {
          return Container(
            height: 200.0,
            child: Center(child: Text('인기 레시피가 아직 없습니다.')),
          );
        }
        return RecipeCard(recipes: recipes);
      },
    );
  }
}
