// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_int_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationIntParams _$PaginationIntParamsFromJson(Map<String, dynamic> json) =>
    PaginationIntParams(
      intAfterId: (json['intAfterId'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationIntParamsToJson(
  PaginationIntParams instance,
) => <String, dynamic>{
  'intAfterId': instance.intAfterId,
  'count': instance.count,
};
