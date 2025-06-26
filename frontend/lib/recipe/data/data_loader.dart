import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/recipe/model/recipe_discounted_ingredient_model.dart';

Future<int?> getMarketItemIdFromIngredient(int ingredientId) async {
  final String jsonStr = await rootBundle.loadString('lib/recipe/data/ingredient_market_mapping.json');
  final List<dynamic> data = json.decode(jsonStr);

  for (final item in data) {
    if (item['ingredient_id'] == ingredientId) {
      return item['ingredient_id'] as int;
    }
  }

  return null; // 해당 id가 없을 경우
}

Future<List<DiscountedIngredient>> loadDiscountedIngredients() async {
  final jsonString = await rootBundle.loadString('lib/recipe/data/dummy_ingredient_prices_with_type.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((e) => DiscountedIngredient.fromJson(e)).toList();
}