import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/repository/search_keyword_repository.dart';

final searchKeywordProvider = StateNotifierProvider.autoDispose<SearchKeywordNotifier, SearchKeywordState>((ref) {
  final repo = ref.watch(searchKeywordRepository);
  return SearchKeywordNotifier(repository: repo);
});

class SearchKeywordNotifier extends StateNotifier<SearchKeywordState> {
  final SearchKeywordRepository repository;

  SearchKeywordNotifier({required this.repository}) : super(SearchKeywordState()) {
    fetchPopular();
    fetchRecent();
  }

  Future<void> fetchPopular() async {
    try {
      final result = await repository.fetchPopular();
      state = state.copyWith(popular: result.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchRecent() async {
    try {
      final result = await repository.fetchRecent(); // result should be List<String>
      state = state.copyWith(recent: result.data);
    } catch (e) {
      rethrow;
    }
  }
}

class SearchKeywordState {
  final List<String>? popular;
  final List<String>? recent;

  SearchKeywordState ({this.popular, this.recent});

  SearchKeywordState copyWith({
    List<String>? popular,
    List<String>? recent,
  }) {
    return SearchKeywordState(
      popular: popular ?? this.popular,
      recent: recent ?? this.recent,
    );
  }
}