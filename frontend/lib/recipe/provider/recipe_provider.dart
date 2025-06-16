import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';

final recipeDetailProvider = FutureProvider.family<RecipeDetailModel, int>((ref, id) async {
  final repository = ref.watch(recipeRepositoryProvider);

  return await repository.getRecipeDetail(id);
});