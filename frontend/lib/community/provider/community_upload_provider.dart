import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/community/model/community_upload_data_model.dart';

import '../../common/const/securetoken.dart';
import 'package:image/image.dart' as img;

//TODO : 에러나는 상황 판단

final communityUploadProvider = Provider<CommunityUpload>((ref) {
  final dio = ref.watch(dioProvider);
  return CommunityUpload(dio);
});

class CommunityUpload {
  final Dio dio;

  CommunityUpload(this.dio);

  Future<Response> uploadPost({
    required File imagefile,
    required CommunityUploadDataModel data,
  }) async {
    try {
      final compressedFile = await _compressImage(imagefile);

      final jsonData = {
        'title': data.title,
        'content': data.content,
        'recipeTag': data.recipeTag,
        'recipeId': data.recipeId,
        'x': data.x,
        'y': data.y,
      };

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          compressedFile.path,
          filename: 'image.jpg',
        ),
        'data': jsonEncode(jsonData),
      });

      final response = await dio.post(
        '$ip/api/community/posts',
        data: formData,
        options: Options(headers: {'accessToken': 'true'}),
      );

      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}

Future<File> _compressImage(File file) async {
  try {
    final bytes = await file.readAsBytes();

    final image = img.decodeImage(bytes);
    if (image == null) return file;

    const maxSize = 1920;
    img.Image resized = image;

    if (image.width > maxSize || image.height > maxSize) {
      resized = img.copyResize(
        image,
        width: image.width > image.height ? maxSize : null,
        height: image.height > image.width ? maxSize : null,
      );
    }

    final compressedBytes = img.encodeJpg(resized, quality: 85);

    final compressedFile = File('${file.path}_compressed.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  } catch (e) {
    print('Image compression error: $e');
    return file; // 압축 실패 시 원본 반환
  }
}
