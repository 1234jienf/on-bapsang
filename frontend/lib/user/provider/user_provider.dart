import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/user/repository/auth_repository.dart';
import 'package:frontend/user/repository/user_repository.dart';

import '../model/user_model.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((
  ref,
) {
  final storage = ref.watch(secureStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return UserStateNotifier(
    storage: storage,
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final FlutterSecureStorage storage;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  UserStateNotifier({
    required this.storage,
    required this.authRepository,
    required this.userRepository,
  }) : super(UserModelLoading()) {
    getMe();
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

      final userResp = await userRepository.getMe();
      state = userResp;
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
    ]);
  }
}
