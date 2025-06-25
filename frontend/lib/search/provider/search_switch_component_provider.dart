import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSwitchComponentNotifier extends StateNotifier<bool> {
  SearchSwitchComponentNotifier() : super(false);

  void switchComponent() {
    state = !state;
  }

  void clear() {
    state = false;
  }
}

final searchSwitchComponentProvider =
    StateNotifierProvider<SearchSwitchComponentNotifier, bool>(
      (ref) => SearchSwitchComponentNotifier(),
    );
