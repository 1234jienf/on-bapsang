import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilterTabIndexProvider extends StateNotifier<int> {
  SearchFilterTabIndexProvider() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final searchFilterTabIndexProvider =
    StateNotifierProvider<SearchFilterTabIndexProvider, int>(
      (ref) => SearchFilterTabIndexProvider(),
    );
