import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/shopping/model/post_shopping_cart_model.dart';


final shoppingCartRepositoryProvider = Provider((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  return ShoppingCartRepository(dio: dio, storage: storage);
});

class ShoppingCartRepository {
  final Dio dio;
  final FlutterSecureStorage storage;
  ShoppingCartRepository({required this.dio, required this.storage});

  Future<Response> getCart() async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);
      final response = await dio.get(
        '$ip/api/cart',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<int>> getIngredientIds() async {
    try {
      String jsonString = await rootBundle.loadString('asset/dummy_data/dummy_ingredients.json');
      List<dynamic> jsonList = json.decode(jsonString);

      List<int> ingredientIds = [];

      for (var item in jsonList) {
        if (item is Map<String, dynamic> && item['ingredient_id'] != null) {
          ingredientIds.add(item['ingredient_id'] as int);
        }
      }
      return ingredientIds;
    } catch (e) {
      print('JSON 파일 읽기 오류: $e');
      return [];
    }
  }

  Future<Response> postCart(List<PostShoppingCartModel> model) async {
    try {
      final List<int> ingredientIds = await getIngredientIds();

      final filteredItems = model
          .where((item) => ingredientIds.contains(item.ingredient_id))
          .map((item) => item.toJson())
          .toList();

      final accessToken = await storage.read(key: ACCESS_TOKEN);
      final response = await dio.post(
        '$ip/api/cart',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
        data: {"items" : filteredItems}
      );
      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> deleteCart(int cartItemId) async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);
      final response = await dio.delete(
        '$ip/api/cart/$cartItemId',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> patchCartItem({
    required int cartItemId,
    required int quantity,
}) async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);
      final response = await dio.patch(
          '$ip/api/cart/$cartItemId',
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        data: {"quantity": quantity},
      );
      print(response.data);
      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}