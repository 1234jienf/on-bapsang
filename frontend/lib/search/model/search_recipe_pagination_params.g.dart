// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recipe_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRecipePaginationParams _$SearchRecipePaginationParamsFromJson(
  Map<String, dynamic> json,
) => SearchRecipePaginationParams(
  name: json['name'] as String,
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchRecipePaginationParamsToJson(
  SearchRecipePaginationParams instance,
) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'name': instance.name,
};
