
class CursorSimplePaginationBase {}

class CursorSimplePaginationError extends CursorSimplePaginationBase {
  final String message;

  CursorSimplePaginationError({required this.message});
}

class CursorSimplePaginationLoading extends CursorSimplePaginationBase {}

class CursorSimplePagination<T> extends CursorSimplePaginationBase {
  final PaginationMeta meta;
  final List<T> data;

  CursorSimplePagination({
    required this.meta,
    required this.data,
  });

  factory CursorSimplePagination.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    return CursorSimplePagination<T>(
      meta: PaginationMeta.fromJson(json['meta']),
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final bool hasMore;

  PaginationMeta({
    required this.currentPage,
    required this.hasMore,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'],
      hasMore: json['hasMore'],
    );
  }
}