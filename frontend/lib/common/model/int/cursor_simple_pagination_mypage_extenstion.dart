import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';

extension CursorSimplePaginationMypage<T> on CursorSimplePagination<T> {
  static CursorSimplePagination<T> fromMypageJson<T>(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    final dataJson = json['data'];

    return CursorSimplePagination<T>(
      meta: PaginationMeta(
        currentPage: dataJson['currentPage'],
        hasMore: dataJson['hasMore'],
      ),
      data: (dataJson['data'] as List<dynamic>).map(fromJsonT).toList(),
    );
  }
}