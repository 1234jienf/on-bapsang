// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_normal_string_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPaginationNormalStringModel<T>
_$CursorPaginationNormalStringModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorPaginationNormalStringModel<T>(
  meta: CursorStringPaginationMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$CursorPaginationNormalStringModelToJson<T>(
  CursorPaginationNormalStringModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'meta': instance.meta,
  'data': instance.data.map(toJsonT).toList(),
};

CursorStringPaginationMeta _$CursorStringPaginationMetaFromJson(
  Map<String, dynamic> json,
) => CursorStringPaginationMeta(
  currentPage: (json['currentPage'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$CursorStringPaginationMetaToJson(
  CursorStringPaginationMeta instance,
) => <String, dynamic>{
  'hasMore': instance.hasMore,
  'currentPage': instance.currentPage,
};
