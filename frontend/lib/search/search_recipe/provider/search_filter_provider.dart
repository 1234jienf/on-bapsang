import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/provider/search_provider.dart';
import 'package:frontend/search/search_recipe/provider/search_filter_apply_provider.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';

import '../../model/search_recipe_model.dart';

final searchFilterProvider = StateNotifierProvider.family<SearchFilterNotifier, List<SearchRecipeModel>, String>((ref, query) {
  return SearchFilterNotifier(ref, query);
});

class SearchFilterNotifier extends StateNotifier<List<SearchRecipeModel>> {
  final Ref ref;
  final String query;
  List<SearchRecipeModel> _data = [];

  SearchFilterNotifier(this.ref, this.query) : super([]) {
    _init();
  }

  void _applyFilter() {
    final filters = ref.read(searchFilterApplyProvider);

    print('=== 필터링 디버깅 ===');
    print('선택된 필터: $filters');
    print('원본 데이터 개수: ${_data.length}');

    if (filters.isEmpty) {
      state = _data;
    } else {
      state = _data.where((recipe) {
        return filters.contains(recipe.material_type);
      }).toList();
    }
  }

  void _init() {
    // 1. 현재 상태 즉시 확인 (초기 데이터)
    final currentState = ref.read(searchProvider(query));
    if (currentState is CursorStringPagination<SearchRecipeModel>) {
      _data = currentState.data;
      _applyFilter();
    }

    // 2. 상태 변경 감지 (추가 데이터 로드시)
    ref.listen(searchProvider(query), (previous, next) {
      if (next is CursorStringPagination<SearchRecipeModel>) {
        _data = next.data;
        _applyFilter();
      }
    });

    // 3. 필터 변경 감지
    ref.listen(searchFilterApplyProvider, (previous, next) {
      _applyFilter();
    });
  }
}