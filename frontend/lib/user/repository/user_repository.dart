import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/user/model/user_patch_model.dart';
import 'package:retrofit/retrofit.dart';

import '../model/user_model.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  
  return UserRepository(dio, baseUrl: '$ip/api/users');
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/me')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @PATCH('/me')
  @Headers({'accessToken': 'true'})
  Future<void> patchUserInfo(
    @Body() UserPatchModel body
  );

  @PATCH('/language')
  @Headers({'accessToken': 'true'})
  Future<void> patchLanguage(
    @Body() Map<String, String> body
  );

  @DELETE('/withdraw')
  @Headers({'accessToken': 'true'})
  Future<void> withdraw();
}