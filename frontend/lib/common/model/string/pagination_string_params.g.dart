// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_string_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationStringParams _$PaginationStringParamsFromJson(
  Map<String, dynamic> json,
) => PaginationStringParams(
  count: (json['count'] as num?)?.toInt(),
  after: json['after'] as String?,
);

Map<String, dynamic> _$PaginationStringParamsToJson(
  PaginationStringParams instance,
) => <String, dynamic>{'after': instance.after, 'count': instance.count};
