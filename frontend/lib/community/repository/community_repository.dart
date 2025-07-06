import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/repository/base_pagination_int_repository.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';
import '../../common/model/int/pagination_int_params.dart';

part 'community_repository.g.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = CommunityRepository(dio, baseUrl: '$ip/api/community');

  return repository;
});

@RestApi()
abstract class CommunityRepository
    implements IBasePaginationIntRepository<CommunityModel> {
  factory CommunityRepository(Dio dio, {String baseUrl}) = _CommunityRepository;

  @override
  @GET('/posts')
  @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<CursorIntPagination<CommunityModel>> paginate({
    @Queries() PaginationIntParams paginationIntParams = const PaginationIntParams()
  });
}
