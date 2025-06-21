import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';
import '../../common/provider/pagination_int_provider.dart';

final communityProvider = StateNotifierProvider.family<CommunityStateNotifier, CursorIntPaginationBase, CommunityParams>((ref, params) {
  final repository = ref.watch(communityRepositoryProvider);
  final notifier = CommunityStateNotifier(repository: repository, keyword : params.keyword, sort : params.sort);
  return notifier;
});

class CommunityStateNotifier
    extends PaginationIntProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({required super.repository, super.keyword, super.sort});
}

class CommunityParams {
  final String? keyword;
  final String? sort;

  CommunityParams({required this.sort, required this.keyword});
}