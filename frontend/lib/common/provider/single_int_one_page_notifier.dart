import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/single_int_one_page_model.dart';

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
      return SingleIntOnePageModel(status: 500, message: 'message', data: _emptyData<T>(),);
    }
  }

  T _emptyData<T>() {
    if (T == List) return [] as T;
    throw UnimplementedError('T 타입에 대한 기본값이 정의되지 않았어요');
  }

  Future<void> refresh() async {
    await fetchData();
  }
}