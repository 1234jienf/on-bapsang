// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/cursor_pagination_int_model.dart';

// 리스트 단일 fetch 쏘는 경우일 때 사용 (페이지네이션 X) 6개만 쏘는 경우 등
class SingleIntStateNotifier<T>
    extends StateNotifier<AsyncValue<CursorIntPagination<T>>> {
  final Future<CursorIntPagination<T>> Function() fetchFunction;

  SingleIntStateNotifier({required this.fetchFunction})
    : super(const AsyncValue.loading());

  Future<CursorIntPaginationData<T>> fetchData() async {
    try {
      state = const AsyncValue.loading();
      final response = await fetchFunction();
      state = AsyncValue.data(response);
      return response.data;
    } catch (error, stackTrace) {
      print("error : $error");
      print("stackTrace : $stackTrace");
      state = AsyncValue.error(error, stackTrace);
      return CursorIntPaginationData(content: []);
    }
  }

  Future<void> refresh() async {
    await fetchData();
  }
}
