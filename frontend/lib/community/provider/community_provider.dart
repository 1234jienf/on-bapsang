import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';
import '../../common/provider/pagination_int_provider.dart';

final communityProvider = StateNotifierProvider.family<CommunityStateNotifier, CursorIntPaginationBase, String?>((ref, keyword) {
  final repository = ref.watch(communityRepositoryProvider);
  final notifier = CommunityStateNotifier(repository: repository, keyword : keyword);
  return notifier;
});

class CommunityStateNotifier
    extends PaginationIntProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({required super.repository, super.keyword});

}
