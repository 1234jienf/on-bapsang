import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({required this.message});
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({required this.meta, required this.data});

  CursorPagination copyWith({
    final CursorPaginationMeta? meta,
    final List<T>? data,
  }) {
    return CursorPagination<T>(
        meta: meta ?? this.meta, data: data ?? this.data);
  }
  
  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final bool? last;
  final bool? hasMore;
  final int totalElements;

  CursorPaginationMeta({required this.totalElements, this.hasMore, this.last});

  CursorPaginationMeta copyWith({
    final int? totalElement,
    final bool? hasMore,
    final bool? last,
}) {
    return CursorPaginationMeta(totalElements: totalElements, last: last ?? this.last, hasMore : hasMore ?? this.hasMore);
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorPaginationMetaFromJson(json);

  // 매칭 시켜줌
  bool get isLast {
    if (hasMore != null) return hasMore!;
    if (last != null) return last!;
    throw StateError('');
  }
}

class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({required super.meta, required super.data});
}

class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({required super.meta, required super.data});
}