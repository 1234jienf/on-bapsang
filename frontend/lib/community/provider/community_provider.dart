import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';
import '../../common/provider/pagination_int_provider.dart';

final communityProvider = StateNotifierProvider<CommunityStateNotifier, CursorIntPaginationBase>((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  final params = ref.watch(currentCommunityParamsProvider);

  return CommunityStateNotifier(
    repository: repository,
    keyword: params.keyword,
    sort: params.sort,
  );
});


class CommunityStateNotifier
    extends PaginationIntProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({
    required super.repository,
    super.keyword,
    super.sort,
  });


  void updateScrapStatus(int id, bool scrapped) {
    if (state is CursorIntPagination) {
      final currentState = state as CursorIntPagination<CommunityModel>;

      final updatedContent = currentState.data.content.map((community) {
        if (community.id == id) {
          return community.copyWith(scrapped: scrapped);
        }
        return community;
      }).toList();

      final updatedData = currentState.data.copyWith(content: updatedContent);

      state = currentState.copyWith(data: updatedData);
    }
  }
}

// 기본 params 처리
final currentCommunityParamsProvider = StateProvider<CommunityParams>((ref) {
  return CommunityParams(sort: 'desc', keyword: null);
});

class CommunityParams {
  final String? keyword;
  final String? sort;

  CommunityParams({required this.sort, required this.keyword});

  CommunityParams copyWith({
    String? keyword,
    String? sort,
  }) {
    return CommunityParams(
      keyword: keyword ?? this.keyword,
      sort: sort ?? this.sort,
    );
  }
}
