import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/repository/base_pagination_repository.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';
import '../model/community_detail_model.dart';

part 'community_repository.g.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = CommunityRepository(dio, baseUrl: '$ip/api/community');

  return repository;
});

@RestApi()
abstract class CommunityRepository
    implements IBasePaginationRepository<CommunityModel> {
  factory CommunityRepository(Dio dio, {String baseUrl}) = _CommunityRepository;

  @override
  @GET('/posts')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<CommunityModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<CommunityDetailModel> getCommunityDetail({
    @Path() required String intId,
  });
}
