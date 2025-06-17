import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';
import 'package:frontend/recipe/repository/recipe_price_repository.dart';

final ingredientTimeSeriesProvider = FutureProvider.family<IngredientTimeSeries, int>((ref, ingredientId) async {
  final repository = ref.watch(recipePriceRepositoryProvider);

  return await repository.getIngredientTimeSeries(ingredientId);
});

final ingredientRegionProvider = FutureProvider.family<IngredientRegion, int>((ref, ingredientId) async {
  final repository = ref.watch(recipePriceRepositoryProvider);

  return await repository.getIngredientRegion(ingredientId);
});