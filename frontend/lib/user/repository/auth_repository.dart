import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/user/model/login_response_model.dart';
import 'dart:io';

import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

// Provider
final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: '$ip/api/auth', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({required this.baseUrl, required this.dio});

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final resp = await dio.post(
      '$baseUrl/login',
      data: {'username': username, 'password': password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return LoginResponseModel.fromJson(resp.data);
  }

  Future<LoginResponseModel> token({required String refreshToken}) async {
    final resp = await dio.post(
      '$baseUrl/refresh',
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization' : 'Bearer $refreshToken'}),
    );
    return LoginResponseModel.fromJson(resp.data);
  }

  Future<void> signup({
    required SignupRequest userInfo
  }) async {
    try {
      final String jsonData = jsonEncode(userInfo.toJson());
      print('[회원가입 요청 데이터]');
      print(jsonData);
      print(userInfo.profileImage!.path);
      final file = userInfo.profileImage!;
      final int fileSizeInBytes = await file.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      print('이미지 파일 크기: ${fileSizeInMB.toStringAsFixed(2)} MB');
      File compressedImage = await compressImage(userInfo.profileImage!);

      // FormData 구성
      final formData = FormData.fromMap({
        'data': jsonData,
        'profileImage': await MultipartFile.fromFile(compressedImage.path),
      });

      // 요청 전송
      await dio.post(
        '$ip/api/users/signup',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data', // 생략해도 되지만 명시해도 무방
        ),
      );
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: ${e.toString()}');
    }
  }
}

Future<File> compressImage(File file) async {
  final raw = await file.readAsBytes();
  final originalImage = img.decodeImage(raw);

  if (originalImage == null) throw Exception('이미지 디코딩 실패');

  final resized = img.copyResize(originalImage, width: 600); // 리사이즈
  final jpg = img.encodeJpg(resized, quality: 85); // 압축률 조절

  final dir = await getTemporaryDirectory();
  final compressed = File('${dir.path}/compressed.jpg');
  await compressed.writeAsBytes(jpg);

  return compressed;
}

