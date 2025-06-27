import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/securetoken.dart';
import '../../common/model/int/cursor_pagination_int_model.dart';

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
abstract class HomeScreenCommunityRepository {
  factory HomeScreenCommunityRepository(Dio dio, {String baseUrl}) =
      _HomeScreenCommunityRepository;

  @GET('/posts')
  @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<CursorIntPagination<CommunityModel>> fetchData({
    @Query('size') int size = 6,
  });
}
