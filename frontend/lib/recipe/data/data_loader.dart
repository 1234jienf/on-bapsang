import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<int?> getMarketItemIdFromIngredient(int ingredientId) async {
  final String jsonStr = await rootBundle.loadString('lib/recipe/data/ingredient_market_mapping.json');
  final List<dynamic> data = json.decode(jsonStr);

  for (final item in data) {
    if (item['ingredient_id'] == ingredientId) {
      return item['market_item_id'] as int;
    }
  }

  return null; // 해당 id가 없을 경우
}