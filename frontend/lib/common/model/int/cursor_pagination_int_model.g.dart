// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_int_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorIntPagination<T> _$CursorIntPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorIntPagination<T>(
  data: CursorIntPaginationData<T>.fromJson(
    json['data'] as Map<String, dynamic>,
    (value) => fromJsonT(value),
  ),
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
);

Map<String, dynamic> _$CursorIntPaginationToJson<T>(
  CursorIntPagination<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data.toJson((value) => toJsonT(value)),
};

CursorIntPaginationData<T> _$CursorIntPaginationDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => CursorIntPaginationData<T>(
  content: (json['content'] as List<dynamic>).map(fromJsonT).toList(),
  pageable:
      json['pageable'] == null
          ? null
          : CursorIntPaginationPageable.fromJson(
            json['pageable'] as Map<String, dynamic>,
          ),
  last: json['last'] as bool?,
);

Map<String, dynamic> _$CursorIntPaginationDataToJson<T>(
  CursorIntPaginationData<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'content': instance.content.map(toJsonT).toList(),
  'pageable': instance.pageable,
  'last': instance.last,
};

CursorIntPaginationPageable _$CursorIntPaginationPageableFromJson(
  Map<String, dynamic> json,
) => CursorIntPaginationPageable(
  pageNumber: (json['pageNumber'] as num).toInt(),
);

Map<String, dynamic> _$CursorIntPaginationPageableToJson(
  CursorIntPaginationPageable instance,
) => <String, dynamic>{'pageNumber': instance.pageNumber};
