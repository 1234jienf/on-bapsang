import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:retrofit/http.dart';

part 'community_repository.g.dart';

final communityRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  
  final repository = CommunityRepository(dio, baseUrl: '$ip/api/community');

  return repository;
});

@RestApi()
abstract class CommunityRepository<CommunityModel> {
  factory CommunityRepository(Dio dio, {String baseUrl}) = _CommunityRepository;
  
  @GET('/posts')
  @Headers({'accessToken' : 'true'})
  Future<void> paginate() async {
    print('');
  }
}