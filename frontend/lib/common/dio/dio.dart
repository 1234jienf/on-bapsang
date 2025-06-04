import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

import '../const/securetoken.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(ref: ref, storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final Ref ref;
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.ref, required this.storage});

  // 1) 요청 보낼 때
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ignore: avoid_print
    print('[REQ], [${options.method}], ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print(
      '[RES], [${response.requestOptions.method}], ${response.requestOptions.uri}',
    );

    super.onResponse(response, handler);
  }

  // 3) 에러 났을 때
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // ignore: avoid_print
    print('[ERR], [${err.requestOptions}], ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    // 인증 오류
    final isStatus401 = err.response?.statusCode == 401;
    // 인증 Path
    final pathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !pathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          '',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        // storage에 accessToken 저장
        storage.write(key: ACCESS_TOKEN, value: accessToken);

        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioException catch (err) {
        // RefreshToken 마저 만료되었을 경우

        //TODO : 로그아웃 구현
        return handler.reject(err);
      }
    }

    return super.onError(err, handler);
  }
}
