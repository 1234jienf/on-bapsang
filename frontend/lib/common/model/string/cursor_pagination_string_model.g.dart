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

Map<String, dynamic> _$CursorStringPaginationToJson<T>(
  CursorStringPagination<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data.map(toJsonT).toList(),
};

CursorStringPaginationMeta _$CursorStringPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorStringPaginationMeta(
  totalElements: (json['totalElements'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
  last: json['last'] as bool?,
);

Map<String, dynamic> _$CursorStringPaginationMetaToJson(
  CursorStringPaginationMeta instance,
) => <String, dynamic>{
  'last': instance.last,
  'hasMore': instance.hasMore,
  'totalElements': instance.totalElements,
};
