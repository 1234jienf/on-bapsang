import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/community/model/community_detail_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/securetoken.dart';
import '../../common/model/wrapper/int_data_wrapper_response.dart';

part 'community_detail_repository.g.dart';

final communityDetailRepositoryProvider = Provider<CommunityDetailRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);

  final repository = _CommunityDetailRepository(
    dio,
    baseUrl: '$ip/api/community',
  );

  return repository;
});


@RestApi()
abstract class CommunityDetailRepository {
  factory CommunityDetailRepository(Dio dio, {String baseUrl}) =
      _CommunityDetailRepository;

  @GET('/posts/{id}')
  @Headers({'accessToken': 'true'})
  Future<IntDataWrapperResponse<CommunityDetailModel>> fetchData({
    @Path() required String id,
  });
}
