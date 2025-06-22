import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/model/int/cursor_pagination_int_model.dart';
import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:frontend/common/repository/base_pagination_int_repository.dart';
import 'package:frontend/mypage/model/mypage_community_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'mypage_community_repository.g.dart';

final mypageCommunityRepositoryProvider = Provider<MypageCommunityRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = MypageCommunityRepository(dio, baseUrl: '$ip/api/mypage');
  return repository;
});

@RestApi()
abstract class MypageCommunityRepository
    implements IBasePaginationIntRepository<MypageCommunityModel> {
  factory MypageCommunityRepository(Dio dio, {String baseUrl}) = _MypageCommunityRepository;

  @override
  @GET('/posts')
  @Headers({'accessToken': 'true'})
  Future<CursorIntPagination<MypageCommunityModel>> paginate({
    @Queries() PaginationIntParams paginationIntParams = const PaginationIntParams()
  });
}

@RestApi()
abstract class MypageScrapCommunityRepository
    implements IBasePaginationIntRepository<MypageCommunityModel> {
  factory MypageScrapCommunityRepository(Dio dio, {String baseUrl}) = _MypageScrapCommunityRepository;

  @override
  @GET('/scraps') // ✅ 여기만 바뀜!
  @Headers({'accessToken': 'true'})
  Future<CursorIntPagination<MypageCommunityModel>> paginate({
    @Queries() PaginationIntParams paginationIntParams = const PaginationIntParams(),
  });
}

final mypageScrapCommunityRepositoryProvider =
Provider<MypageScrapCommunityRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MypageScrapCommunityRepository(dio, baseUrl: '$ip/api/mypage');
});