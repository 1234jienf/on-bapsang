import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';

import '../../common/const/securetoken.dart';

final communityCommentUploadProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return CommunityCommentUploadModel(dio);
});

class CommunityCommentUploadModel {
  final Dio dio;

  CommunityCommentUploadModel(this.dio);

  Future<Response> uploadCommentPost({
    required String id,
    required String content,
    required int? parentId,
  }) async {
    print(id);
    try {
      final jsonData = {'content': content, 'parentId': parentId};

      final response = await dio.post(
        '$ip/api/community/comments/$id',
        data: jsonData,
        options: Options(headers: {'accessToken' : 'true'}),
      );

      return response;
    } on DioException {
      rethrow;
    }
  }
}
