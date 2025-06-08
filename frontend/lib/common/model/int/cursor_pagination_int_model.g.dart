// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_int_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorIntPagination<T> _$CursorIntPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorIntPagination<T>(
  meta: CursorIntPaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$CursorIntPaginationToJson<T>(
  CursorIntPagination<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data.map(toJsonT).toList(),
};

CursorIntPaginationMeta _$CursorIntPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorIntPaginationMeta(
  totalElements: (json['totalElements'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
  last: json['last'] as bool?,
);

Map<String, dynamic> _$CursorIntPaginationMetaToJson(
  CursorIntPaginationMeta instance,
) => <String, dynamic>{
  'last': instance.last,
  'hasMore': instance.hasMore,
  'totalElements': instance.totalElements,
};
