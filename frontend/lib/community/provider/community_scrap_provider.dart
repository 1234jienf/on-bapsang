import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';

import '../../common/const/securetoken.dart';

final communityScrapProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return CommunityScrapProvider(dio);

});

class CommunityScrapProvider {
  final Dio dio;

  CommunityScrapProvider(this.dio);

  Future<Response> scrap({
    required String id,
  }) async {
    try {
      final response = await dio.post(
        '$ip/api/community/scrap/$id',
        options: Options(headers: {'accessToken' : 'true'}),
      );

      return response;

    } on DioException catch (e) {
      rethrow;
    }
  }
}