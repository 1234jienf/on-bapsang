import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/pagination/recipe_simple_pagination_notifier.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';

import '../notifier/category_pagination_notifier.dart';


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

final categoryPaginationProvider = StateNotifierProvider.autoDispose.family<CategoryPaginationNotifier, CursorStringPaginationBase, String>((ref, category) {
  ref.keepAlive();

  final repository = ref.read(recipeRepositoryProvider);
  final dio = ref.read(dioProvider);

  return CategoryPaginationNotifier(
    repository: repository,
    dio: dio,
    category: category,
  );
});


final seasonIngredientRecipeProvider = StateNotifierProvider.family<
    RecipeSimplePaginationNotifier<RecipeModel>,
    CursorSimplePaginationBase,
    String?>((ref, name) {
  final repository = ref.watch(recipeRepositoryProvider);
  return RecipeSimplePaginationNotifier<RecipeModel>(
    repository: repository,
    name: name,
  );
});

final topRecipesByIngredientProvider =
FutureProvider.family<List<RecipeModel>, String>((ref, ingredientName) async {
  final repository = ref.watch(recipeRepositoryProvider);
  final response = await repository.getSeasonRecipeMainRaw(ingredientName, 0, 10);
  final List<dynamic> data = response.data['data'];
  return data.map((e) => RecipeModel.fromJson(e)).toList();
});