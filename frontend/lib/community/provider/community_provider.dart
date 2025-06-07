import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/pagination_provider.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

class CommunityStateNotifier extends PaginationProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({required super.repository});

  void getDetail({required int intId}) async {
    if (state is! CursorPagination) {
      await paginate();
    }

    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    // TODO : resp
    final resp = [];

    // 캐시
    if (pState.data.where((e) => e.id == intId).isEmpty) {
      state = pState.copyWith(data : <CommunityModel>[...pState.data, ]);
    } else {
      state = pState.copyWith(data : pState.data.map<CommunityModel>((e) => e.id == intId ? resp : e).toList());
    }

  }
}