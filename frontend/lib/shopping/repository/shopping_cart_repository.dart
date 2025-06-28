import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

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

      print("repo : $response");

      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}