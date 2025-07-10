import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/shopping/model/ingredient_item_model.dart';


// 전체 리스트 가져오기
Future<List<IngredientItemModel>> loadIngredientItems() async {
  final jsonString = await rootBundle.loadString('asset/dummy_data/dummy_ingredients.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((e) => IngredientItemModel.fromJson(e)).toList();
}

// 카테고리별 리스트 가져오기
Future<List<IngredientItemModel>> loadIngredientItemsByCategory(String category) async {
  final jsonString = await rootBundle.loadString('asset/dummy_data/dummy_ingredients.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  final dataList = jsonList.map((e) => IngredientItemModel.fromJson(e)).toList();

  final filteredList = dataList.where((item) => item.materialType == category).toList();
  return filteredList;
}