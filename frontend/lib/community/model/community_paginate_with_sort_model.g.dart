// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_paginate_with_sort_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityPaginateWithSortModel _$CommunityPaginateWithSortModelFromJson(
  Map<String, dynamic> json,
) => CommunityPaginateWithSortModel(
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  sort: json['sort'] as String,
);

Map<String, dynamic> _$CommunityPaginateWithSortModelToJson(
  CommunityPaginateWithSortModel instance,
) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'sort': instance.sort,
};
