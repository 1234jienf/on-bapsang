import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/cursor_pagination_int_model.dart';
import 'package:frontend/common/provider/pagination_int_provider.dart';
import 'package:frontend/mypage/model/mypage_community_model.dart';
import 'package:frontend/mypage/repository/mypage_community_repository.dart';

final mypageCommunityProvider = StateNotifierProvider.family<
    MypageCommunityStateNotifier,
    CursorIntPaginationBase,
    CommunityParams
>((ref, params) {
  final repository = ref.watch(mypageCommunityRepositoryProvider);
  return MypageCommunityStateNotifier(
    repository: repository,
    keyword: params.keyword,
    sort: params.sort,
  );
});

class MypageCommunityStateNotifier
    extends PaginationIntProvider<MypageCommunityModel, MypageCommunityRepository> {
  MypageCommunityStateNotifier({required super.repository, super.keyword, super.sort});
}

class CommunityParams {
  final String? keyword;
  final String? sort;

  CommunityParams({required this.sort, required this.keyword});
}

final mypageScrapCommunityProvider = StateNotifierProvider.family<
    MypageScrapCommunityStateNotifier,
    CursorIntPaginationBase,
    CommunityParams>((ref, params) {
  final repository = ref.watch(mypageScrapCommunityRepositoryProvider);
  return MypageScrapCommunityStateNotifier(
    repository: repository,
    keyword: params.keyword,
    sort: params.sort,
  );
});

class MypageScrapCommunityStateNotifier extends PaginationIntProvider<
    MypageCommunityModel,
    MypageScrapCommunityRepository> {
  MypageScrapCommunityStateNotifier({
    required super.repository,
    super.keyword,
    super.sort,
  });
}