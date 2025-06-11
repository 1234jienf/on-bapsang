import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_string_model.g.dart';

abstract class CursorStringPaginationBase {}

class CursorStringPaginationError extends CursorStringPaginationBase {
  final String message;

  CursorStringPaginationError({required this.message});
}

class CursorStringPaginationLoading extends CursorStringPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorStringPagination<T> extends CursorStringPaginationBase {

  final CursorStringPaginationMeta meta;
  final List<T> data;

  CursorStringPagination({required this.meta, required this.data});

  CursorStringPagination copyWith({
    final CursorStringPaginationMeta? meta,
    final List<T>? data,
  }) {
    return CursorStringPagination<T>(
        meta: meta ?? this.meta, data: data ?? this.data);
  }
  
  factory CursorStringPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$CursorStringPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorStringPaginationMeta {
  final bool hasMore;
  final int currentPage;

  CursorStringPaginationMeta({required this.currentPage, required this.hasMore});

  CursorStringPaginationMeta copyWith({
    final int? currentPage,
    final bool? hasMore,
}) {
    return CursorStringPaginationMeta(currentPage: currentPage ?? this.currentPage, hasMore : hasMore ?? this.hasMore);
  }

  factory CursorStringPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorStringPaginationMetaFromJson(json);
}

class CursorStringPaginationRefetching<T> extends CursorStringPagination<T> {
  CursorStringPaginationRefetching({required super.meta, required super.data});
}

class CursorStringPaginationFetchingMore<T> extends CursorStringPagination<T> {
  CursorStringPaginationFetchingMore({required super.meta, required super.data});
}