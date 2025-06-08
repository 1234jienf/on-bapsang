import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_int_model.g.dart';

abstract class CursorIntPaginationBase {}

class CursorIntPaginationError extends CursorIntPaginationBase {
  final String message;

  CursorIntPaginationError({required this.message});
}

class CursorIntPaginationLoading extends CursorIntPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorIntPagination<T> extends CursorIntPaginationBase {

  final CursorIntPaginationMeta meta;
  final List<T> data;

  CursorIntPagination({required this.meta, required this.data});

  CursorIntPagination copyWith({
    final CursorIntPaginationMeta? meta,
    final List<T>? data,
  }) {
    return CursorIntPagination<T>(
        meta: meta ?? this.meta, data: data ?? this.data);
  }

  factory CursorIntPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$CursorIntPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorIntPaginationMeta {
  final bool? last;
  final bool? hasMore;
  final int totalElements;

  CursorIntPaginationMeta({required this.totalElements, this.hasMore, this.last});

  CursorIntPaginationMeta copyWith({
    final int? totalElement,
    final bool? hasMore,
    final bool? last,
  }) {
    return CursorIntPaginationMeta(totalElements: totalElements, last: last ?? this.last, hasMore : hasMore ?? this.hasMore);
  }

  factory CursorIntPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorIntPaginationMetaFromJson(json);

  // 매칭 시켜줌
  bool get isLast {
    if (hasMore != null) return hasMore!;
    if (last != null) return last!;
    throw StateError('');
  }
}

class CursorIntPaginationRefetching<T> extends CursorIntPagination<T> {
  CursorIntPaginationRefetching({required super.meta, required super.data});
}

class CursorIntPaginationFetchingMore<T> extends CursorIntPagination<T> {
  CursorIntPaginationFetchingMore({required super.meta, required super.data});
}