import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/wrapper/int_data_wrapper_response.dart';
import '../model/wrapper/int_list_wrapper_response.dart';

class SingleIntListStateNotifier<T> extends StateNotifier<AsyncValue<IntListWrapperResponse<T>>> {
  final Future<IntListWrapperResponse<T>> Function() fetchFunction;

  SingleIntListStateNotifier({required this.fetchFunction}) : super(const AsyncValue.loading());

  Future<List<T>> fetchData() async {
    state = const AsyncValue.loading();
    final response = await fetchFunction();
    state = AsyncValue.data(response);
    return response.result;
  }

  Future<void> refresh() async {
    await fetchData();
  }
}

class SingleIntDataStateNotifier<T> extends StateNotifier<AsyncValue<IntDataWrapperResponse<T>>> {
  final Future<IntDataWrapperResponse<T>> Function() fetchFunction;

  SingleIntDataStateNotifier({required this.fetchFunction}) : super(const AsyncValue.loading());

  Future<T> fetchData() async {
    state = const AsyncValue.loading();
    final response = await fetchFunction();
    state = AsyncValue.data(response);
    return response.result;
  }

  Future<void> refresh() async {
    await fetchData();
  }
}