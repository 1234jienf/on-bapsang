import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/mypage/provider/mypage_provider.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:frontend/recipe/provider/recipe_season_provider.dart';
import 'package:frontend/user/repository/auth_repository.dart';
import 'package:frontend/user/repository/user_repository.dart';

import '../model/user_model.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

final languageProvider = StateProvider<String?>((_) => null);

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((
  ref,
) {
  final storage = ref.watch(secureStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return UserStateNotifier(
    ref: ref,
    storage: storage,
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final Ref _ref;
  final FlutterSecureStorage storage;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  UserStateNotifier({
    required Ref ref,
    required this.storage,
    required this.authRepository,
    required this.userRepository,
  }) : _ref = ref,
        super(UserModelLoading()) {
    getMe();
  }

  Future<void> _applyLanguage(String? lang) async {
    if (lang == null || lang.isEmpty) return;

    await storage.write(key: LANGUAGE_KEY, value: lang);
    _ref.read(languageProvider.notifier).state = lang;

    final dio = _ref.read(dioProvider);
    dio.options.headers['X-Language'] = lang;
  }

  Future<void> getMe() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN);
    final refreshToken = await storage.read(key: REFRESH_TOKEN);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }
    final resp = await userRepository.getMe();
    state = resp;

    await _applyLanguage(resp.country);
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await Future.wait([
        storage.write(key: ACCESS_TOKEN, value: resp.accessToken),
        storage.write(key: REFRESH_TOKEN, value: resp.refreshToken),
      ]);

      _ref.invalidate(dioProvider);

      final userResp = await userRepository.getMe();
      state = userResp;

      await _applyLanguage(userResp.country);

      _ref.invalidate(mypageInfoProvider);  // 마이페이지 정보 강제 새로고침
      _ref.invalidate(popularRecipesProvider); // 메인페이지 정보도 새로 고침
      _ref.invalidate(recommendRecipesProvider);
      _ref.invalidate(seasonIngredientProvider);

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: ACCESS_TOKEN),
      storage.delete(key: REFRESH_TOKEN),
      storage.delete(key: LANGUAGE_KEY),
    ]);

    _ref.read(languageProvider.notifier).state = null;
    _ref.read(dioProvider).options.headers.remove('X-Language');

    _ref.invalidate(dioProvider);

    _ref.invalidate(mypageInfoProvider);
    _ref.invalidate(popularRecipesProvider); // 메인페이지 정보도 새로 고침
    _ref.invalidate(recommendRecipesProvider);
    _ref.invalidate(seasonIngredientProvider);
  }

  Future<void> signup({
    required SignupRequest userInfo
  }) async {
    try {
      state = UserModelLoading();
      await authRepository.signup(userInfo: userInfo);

      state = null;
      login(username: userInfo.username, password: userInfo.password);
    } catch (e) {
      state = UserModelError(message: '회원가입에 실패했습니다.');
      print(e.toString());
      rethrow;
    }
  }
}