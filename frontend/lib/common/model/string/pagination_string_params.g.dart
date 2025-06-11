// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_string_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationStringParams _$PaginationStringParamsFromJson(
  Map<String, dynamic> json,
) => PaginationStringParams(
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationStringParamsToJson(
  PaginationStringParams instance,
) => <String, dynamic>{'page': instance.page, 'size': instance.size};
