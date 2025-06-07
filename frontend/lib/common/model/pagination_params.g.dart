// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      intAfterId: (json['intAfterId'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      stringAfterId: json['stringAfterId'] as String?,
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'intAfterId': instance.intAfterId,
      'stringAfterId': instance.stringAfterId,
      'count': instance.count,
    };
