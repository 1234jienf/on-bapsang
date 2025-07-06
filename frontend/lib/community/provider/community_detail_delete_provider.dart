import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

import '../../common/const/securetoken.dart';

final communityDetailDeleteProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.read(secureStorageProvider);
  return CommunityDetailDeleteProvider(dio, storage);
});

class CommunityDetailDeleteProvider {
  final Dio dio;
  final FlutterSecureStorage storage;

  CommunityDetailDeleteProvider(this.dio, this.storage);

  Future<Response> deleteDetail(int detailId) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      final resp = await dio.delete(
        '$ip/api/community/posts/$detailId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}, validateStatus: (status) {
          return status != null && status <= 500;
        }),
      );
      return resp;
    } on DioException catch (e) {
      rethrow;
    }
  }

}