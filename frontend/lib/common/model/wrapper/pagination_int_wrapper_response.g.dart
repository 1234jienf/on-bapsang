// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_int_wrapper_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationIntWrapperResponse<T> _$PaginationIntWrapperResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginationIntWrapperResponse<T>(
  message: json['message'] as String,
  status: (json['status'] as num).toInt(),
  result: CursorIntPagination<T>.fromJson(
    json['result'] as Map<String, dynamic>,
    (value) => fromJsonT(value),
  ),
);

Map<String, dynamic> _$PaginationIntWrapperResponseToJson<T>(
  PaginationIntWrapperResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'message': instance.message,
  'status': instance.status,
  'result': instance.result,
};
