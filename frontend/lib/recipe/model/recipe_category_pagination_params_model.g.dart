// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_category_pagination_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryPaginationIntParams _$CategoryPaginationIntParamsFromJson(
  Map<String, dynamic> json,
) => CategoryPaginationIntParams(
  category: json['category'] as String,
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$CategoryPaginationIntParamsToJson(
  CategoryPaginationIntParams instance,
) => <String, dynamic>{
  'category': instance.category,
  'page': instance.page,
  'size': instance.size,
};
