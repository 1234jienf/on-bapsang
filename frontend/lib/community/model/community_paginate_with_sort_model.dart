import 'package:json_annotation/json_annotation.dart';

import '../../common/model/int/pagination_int_params.dart';

part 'community_paginate_with_sort_model.g.dart';

@JsonSerializable()
class CommunityPaginateWithSortModel extends PaginationIntParams {
  final String sort;

  const CommunityPaginateWithSortModel({
    super.page,
    super.size,
    required this.sort,
  });

  @override
  CommunityPaginateWithSortModel copyWith({int? page, int? size}) {
    return CommunityPaginateWithSortModel(
      sort: sort,
      size: size ?? this.size,
      page: page ?? this.page,
    );
  }

  factory CommunityPaginateWithSortModel.fromJson(Map<String, dynamic> json) => _$CommunityPaginateWithSortModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CommunityPaginateWithSortModelToJson(this);
}
