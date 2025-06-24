import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSwitchComponentNotifier extends StateNotifier<bool> {
  SearchSwitchComponentNotifier() : super(false);

  void switchComponent() {
    state = !state;
  }
}

final searchSwitchComponentProvider =
    StateNotifierProvider<SearchSwitchComponentNotifier, bool>(
      (ref) => SearchSwitchComponentNotifier(),
    );
