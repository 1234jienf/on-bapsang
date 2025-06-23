import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchKeywordRemianNotifier extends StateNotifier<String> {
  SearchKeywordRemianNotifier() : super("");

  void setKeyword(String keyword) {
    state = keyword;
  }

  void clear() {
    state = "";
  }
}

final searchKeywordRemainProvider =
    StateNotifierProvider<SearchKeywordRemianNotifier, String>(
      (ref) => SearchKeywordRemianNotifier(),
    );
