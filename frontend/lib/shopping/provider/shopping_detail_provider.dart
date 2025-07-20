import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

import '../../common/const/securetoken.dart';
import '../../common/dio/dio.dart';
import '../model/shopping_detail_model.dart';

final shoppingDetailRepositoryProvider = Provider<ShoppingDetailRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ShoppingDetailRepository(dio: dio, storage: storage);
});

final shoppingDetailProvider = FutureProvider.family<ShoppingDetailModel, String>((ref, id) {
  final repository = ref.watch(shoppingDetailRepositoryProvider);
  return repository.fetchDetail(id);
});

class ShoppingDetailRepository {
  final Dio dio;
  final FlutterSecureStorage storage;

  ShoppingDetailRepository({required this.dio, required this.storage});

  Future<ShoppingDetailModel> fetchDetail(String id) async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);

      final response = await dio.get(
        '$ip/api/ingredient/shop/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200) {
        return ShoppingDetailModel.fromJson(response.data);
      } else {
        throw Exception();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('${e.message}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}