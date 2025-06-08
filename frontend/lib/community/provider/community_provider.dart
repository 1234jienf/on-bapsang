import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';
import '../../common/provider/pagination_int_provider.dart';

final communityProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  final notifier = CommunityStateNotifier(repository: repository);
  return notifier;
});

class CommunityStateNotifier extends PaginationIntProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({required super.repository});

  void getDetail({required int intId}) async {
    if (state is! CursorIntPagination) {
      await paginate();
    }

    if (state is! CursorIntPagination) {
      return;
    }

    final pState = state as CursorIntPagination;

    // TODO : resp
    final resp = await repository.getCommunityDetail(intId: intId);

    // 캐시
    if (pState.data.where((e) => e.id == intId).isEmpty) {
      state = pState.copyWith(data : <CommunityModel>[...pState.data, ]);
    } else {
      state = pState.copyWith(data : pState.data.map<CommunityModel>((e) => e.id == intId ? resp : e).toList());
    }

  }
}