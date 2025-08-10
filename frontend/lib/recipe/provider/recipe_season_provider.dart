import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/model/recipe_season_ingredient_model.dart';
import 'package:frontend/recipe/repository/recipe_season_repository.dart';
import 'package:frontend/user/provider/user_provider.dart';

/// 제철재료 정보 가져오기
final seasonIngredientProvider = FutureProvider<List<RecipeSeasonIngredientModel>>((ref) async {
  final user = ref.watch(userProvider);
  // if (user == null) return [];

  final repository = ref.watch(recipeSeasonRepositoryProvider);
  final month = DateTime.now().month; // 현재 달 기준
  return await repository.getSeasonIngredients(month);
});
