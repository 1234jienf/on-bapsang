import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchDetailTabIndexNotifier extends StateNotifier<int> {
  SearchDetailTabIndexNotifier() : super(0);

  void setIndexUp() {
    if (state < 2) state++;
  }

  void setIndexDown() {
    if (state > 0) state--;
  }
}

final searchDetailTabIndexProvider =
    StateNotifierProvider<SearchDetailTabIndexNotifier, int>(
      (ref) => SearchDetailTabIndexNotifier(),
    );
