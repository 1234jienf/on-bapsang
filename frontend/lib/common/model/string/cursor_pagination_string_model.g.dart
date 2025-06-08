// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_string_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorStringPagination<T> _$CursorStringPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorStringPagination<T>(
  meta: CursorStringPaginationMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
);


CursorStringPaginationMeta _$CursorStringPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorStringPaginationMeta(
  totalElements: (json['totalElements'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

