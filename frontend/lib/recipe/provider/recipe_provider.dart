import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';


/// 인기 레시피 가져오기
final popularRecipesProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return await repository.getPopularRecipes();
});

/// 추천 레시피 가져오기
final recommendRecipesProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return await repository.getRecommendRecipes();
});

// 레시피 상세 가져오기
final recipeDetailProvider = FutureProvider.family<RecipeDetailModel, int>((ref, id) async {
  final repository = ref.watch(recipeRepositoryProvider);

  return await repository.getRecipeDetail(id);
});
