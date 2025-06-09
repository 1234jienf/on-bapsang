import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/cursor_pagination_int_model.dart';

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
