import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/dio/dio.dart';

import '../../common/const/securetoken.dart';
import '../../common/secure_storage/secure_storage.dart';

final communityScrapProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return CommunityScrapProvider(dio, storage);

});

class CommunityScrapProvider {
  final Dio dio;
  final FlutterSecureStorage storage;

  CommunityScrapProvider(this.dio, this.storage);

  Future<Response> scrap({
    required String id,
  }) async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN);
      final response = await dio.post(
        '$ip/api/community/scrap/$id',
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
}