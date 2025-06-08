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


CursorIntPaginationMeta _$CursorIntPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorIntPaginationMeta(
  totalElements: (json['totalElements'] as num).toInt(),
  last: json['last'] as bool,
);

