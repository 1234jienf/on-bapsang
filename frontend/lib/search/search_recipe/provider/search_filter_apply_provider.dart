import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchFilterApplyProvider =
    StateNotifierProvider<SearchFilterApplyNotifier, Set<String>>((ref) {
      return SearchFilterApplyNotifier();
    });

class SearchFilterApplyNotifier extends StateNotifier<Set<String>> {
  SearchFilterApplyNotifier() : super({});

  void toggle(String item) {
    if (state.contains(item)) {
      state = {...state}..remove(item);
    } else {
      state = {...state, item};
    }
  }

  void clear() {
    state = {};
  }
}
