// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_search_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunitySearchPaginationParams _$CommunitySearchPaginationParamsFromJson(
  Map<String, dynamic> json,
) => CommunitySearchPaginationParams(
  keyword: json['keyword'] as String?,
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  sort: json['sort'] as String?,
);

Map<String, dynamic> _$CommunitySearchPaginationParamsToJson(
  CommunitySearchPaginationParams instance,
) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'keyword': instance.keyword,
  'sort': instance.sort,
};
