import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleStateNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final Future<List<T>> Function() fetchFunction;

  SingleStateNotifier({required this.fetchFunction}) : super(const AsyncValue.loading());

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    final result = await fetchFunction();
    state = AsyncValue.data(result);
  }

  Future<void> refresh() async {
    await fetchData();
  }
}