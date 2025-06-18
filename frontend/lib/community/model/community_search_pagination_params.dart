import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_search_pagination_params.g.dart';

@JsonSerializable()
class CommunitySearchPaginationParams extends PaginationIntParams {
  final String? keyword;
  final String? sort;

  CommunitySearchPaginationParams({this.keyword, super.page, super.size, this.sort});

  @override
  CommunitySearchPaginationParams copyWith({
    int? page,
    int? size,
    String? keyword,
  }) {
    return CommunitySearchPaginationParams(
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory CommunitySearchPaginationParams.fromJson(Map<String, dynamic> json) => _$CommunitySearchPaginationParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CommunitySearchPaginationParamsToJson(this);
}
