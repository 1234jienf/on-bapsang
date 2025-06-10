// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_int_one_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleIntOnePageModel<T> _$SingleIntOnePageModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => SingleIntOnePageModel<T>(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$SingleIntOnePageModelToJson<T>(
  SingleIntOnePageModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': toJsonT(instance.data),
};
