import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/mypage/model/mypage_userInfo_model.dart';
import 'package:retrofit/retrofit.dart';

part 'mypage_repository.g.dart';

final mypageRepositoryProvider = Provider<MypageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MypageRepository(dio, baseUrl: '$ip/api');
});

@RestApi()
abstract class MypageRepository {
  factory MypageRepository(Dio dio, {String baseUrl}) = _MypageRepository;

  @GET('/users/me')
  @Headers({'accessToken': 'true'})
  Future<MypageResponseModel> getMypageData();
}