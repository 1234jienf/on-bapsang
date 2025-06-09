// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'int_data_wrapper_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntDataWrapperResponse<T> _$IntDataWrapperResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => IntDataWrapperResponse<T>(
  message: json['message'] as String,
  status: (json['status'] as num).toInt(),
  result: fromJsonT(json['result']),
);

Map<String, dynamic> _$IntDataWrapperResponseToJson<T>(
  IntDataWrapperResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'message': instance.message,
  'status': instance.status,
  'result': toJsonT(instance.result),
};
