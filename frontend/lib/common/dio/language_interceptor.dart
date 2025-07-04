import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/user/provider/user_provider.dart';

// 언어 설정이 필요한 api에는 extra:{'useLang':true}를 추가
class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(this.ref, this.storage);

  final Ref ref;
  final FlutterSecureStorage storage;

  @override
  Future<void> onRequest(RequestOptions o, RequestInterceptorHandler h) async {
    if (o.extra['useLang'] == true) {
      var lang = ref.read(languageProvider);
      lang ??= await storage.read(key: LANGUAGE_KEY);

      if (lang != null && lang.isNotEmpty) {
        // 메모리 캐시 최신화(한 번만 읽도록)
        ref.read(languageProvider.notifier).state = lang;
        o.headers['X-Language'] = lang;
      }
    }
    if (kDebugMode) {
      // debugPrint('[LanguageInterceptor] ${o.method} ${o.uri}');
      debugPrint('→ X-Language: ${o.headers['X-Language']}');
      // debugPrint('→ All headers: ${o.headers}');
    }
    h.next(o);
  }
}
