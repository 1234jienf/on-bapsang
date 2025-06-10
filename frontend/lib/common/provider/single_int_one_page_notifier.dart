// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/single_int_one_page_model.dart';

// 세부 페이지 (페이지네이션X) 보여주는 페이지
class SingleIntOnePageNotifier<T>
    extends StateNotifier<AsyncValue<SingleIntOnePageModel<T>>> {
  final Future<SingleIntOnePageModel<T>> Function() fetchFunction;

  SingleIntOnePageNotifier({required this.fetchFunction})
      : super(const AsyncValue.loading());

  Future<SingleIntOnePageModel<T>> fetchData() async {
    try {
      state = const AsyncValue.loading();
      final response = await fetchFunction();
      state = AsyncValue.data(response);
      return response;
    } catch (error, stackTrace) {
      print("error : $error");
      print("stackTrace : $stackTrace");
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await fetchData();
  }
}