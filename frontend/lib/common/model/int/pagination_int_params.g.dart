// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_int_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationIntParams _$PaginationIntParamsFromJson(Map<String, dynamic> json) =>
    PaginationIntParams(
      size: (json['size'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationIntParamsToJson(
  PaginationIntParams instance,
) => <String, dynamic>{'page': instance.page, 'size': instance.size};
