// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recipe_normal_list_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRecipeNormalListView _$SearchRecipeNormalListViewFromJson(
  Map<String, dynamic> json,
) => SearchRecipeNormalListView(
  name: json['name'] as String,
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchRecipeNormalListViewToJson(
  SearchRecipeNormalListView instance,
) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'name': instance.name,
};
