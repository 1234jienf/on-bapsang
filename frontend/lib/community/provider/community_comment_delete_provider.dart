import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

final communityCommentDeleteProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.read(secureStorageProvider);
  return CommunityCommentDeleteProvider(dio, storage);
});

class CommunityCommentDeleteProvider {
  final Dio dio;
  final FlutterSecureStorage storage;

  CommunityCommentDeleteProvider(this.dio, this.storage);

  Future<Response> deleteComment(int commentId) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      final resp = await dio.delete(
        '$ip/api/community/comments/$commentId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return resp;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
