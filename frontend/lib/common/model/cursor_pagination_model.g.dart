// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPagination<T> _$CursorPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorPagination<T>(
  meta: CursorPaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
);

// ignore: unused_element
Map<String, dynamic> _$CursorPaginationToJson<T>(
  CursorPagination<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data.map(toJsonT).toList(),
};

CursorPaginationMeta _$CursorPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorPaginationMeta(
  totalElements: (json['totalElements'] as num).toInt(),
  hasMore: json['hasMore'] as bool?,
  last: json['last'] as bool?,
);

// ignore: unused_element
Map<String, dynamic> _$CursorPaginationMetaToJson(
  CursorPaginationMeta instance,
) => <String, dynamic>{
  'last': instance.last,
  'hasMore': instance.hasMore,
  'totalElements': instance.totalElements,
};
