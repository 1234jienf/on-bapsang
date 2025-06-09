// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'int_list_wrapper_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntListWrapperResponse<T> _$IntListWrapperResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => IntListWrapperResponse<T>(
  message: json['message'] as String,
  status: (json['status'] as num).toInt(),
  result: (json['result'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$IntListWrapperResponseToJson<T>(
  IntListWrapperResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'message': instance.message,
  'status': instance.status,
  'result': instance.result.map(toJsonT).toList(),
};
