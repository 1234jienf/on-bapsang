import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/securetoken.dart';
import '../../common/model/wrapper/pagination_int_wrapper_response.dart';

part 'home_screen_community_repository.g.dart';

final homeScreenCommunityRepositoryProvider =
    Provider<HomeScreenCommunityRepository>((ref) {
      final dio = ref.watch(dioProvider);

      final repository = HomeScreenCommunityRepository(
        dio,
        baseUrl: '$ip/api/community',
      );

      return repository;
    });

@RestApi()
abstract class HomeScreenCommunityRepository<CommuintyModel> {
  factory HomeScreenCommunityRepository(Dio dio, {String baseUrl}) =
      _HomeScreenCommunityRepository;


  @GET('/posts')
  @Headers({'accessToken': 'true'})
  Future<PaginationIntWrapperResponse<CommunityModel>> fetchData({@Query('size') int size = 6});
}
