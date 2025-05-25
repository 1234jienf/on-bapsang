import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTabIndexNotifier extends StateNotifier<int> {
  SearchTabIndexNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final searchTabIndexProvider =
    StateNotifierProvider<SearchTabIndexNotifier, int>(
      (ref) => SearchTabIndexNotifier(),
    );
