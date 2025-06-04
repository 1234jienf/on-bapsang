import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/user/model/login_response_model.dart';

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
}
