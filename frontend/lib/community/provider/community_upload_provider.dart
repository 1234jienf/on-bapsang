import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/community/model/community_upload_data_model.dart';

import '../../common/const/securetoken.dart';
import 'package:image/image.dart' as img;

final communityUploadProvider = Provider<CommunityUpload>((ref) {
  final dio = ref.watch(dioProvider);
  return CommunityUpload(dio);
});

class CommunityUpload {
  final Dio dio;

  CommunityUpload(this.dio);

  Future<Response> uploadPost({
    required Uint8List imageData,
    required CommunityUploadDataModel data,
  }) async {
    try {
      final compressedData = await _compressImageData(imageData);

      final jsonData = {
        'title': data.title,
        'content': data.content,
        'recipeTag': data.recipeTag,
        'recipeId': data.recipeId,
        'x': data.x,
        'y': data.y,
      };

      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          compressedData,
          filename: 'image.jpg',
        ),
        'data': jsonEncode(jsonData),
      });

      final response = await dio.post(
        '$ip/api/community/posts',
        data: formData,
        options: Options(
          headers: {'accessToken': 'true'},
          validateStatus: (status) {
            return status != null && status <= 500;
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }
}

Future<Uint8List> _compressImageData(Uint8List imageData) async {
  try {
    final image = img.decodeImage(imageData);
    if (image == null) return imageData;

    const maxSize = 1200;
    img.Image resized = image;

    if (image.width > maxSize || image.height > maxSize) {
      if (image.width > 3000 || image.height > 3000) {
        final newWidth = image.width ~/ 2;
        final newHeight = image.height ~/ 2;

        resized = img.copyResize(image, width: newWidth, height: newHeight);
      }

      final aspectRatio = resized.width / resized.height;
      int finalWidth, finalHeight;

      if (resized.width > resized.height) {
        finalWidth = maxSize;
        finalHeight = (maxSize / aspectRatio).round();
      } else {
        finalHeight = maxSize;
        finalWidth = (maxSize * aspectRatio).round();
      }

      resized = img.copyResize(resized, width: finalWidth, height: finalHeight);
    }

    final compressedBytes = img.encodeJpg(resized, quality: 80);

    return Uint8List.fromList(compressedBytes);
  } catch (e) {
    print('이미지 압축 에러: $e');
    return imageData;
  }
}