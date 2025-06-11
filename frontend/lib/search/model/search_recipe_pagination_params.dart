import 'package:json_annotation/json_annotation.dart';
import '../../common/model/string/pagination_string_params.dart';

part 'search_recipe_pagination_params.g.dart';

@JsonSerializable()
class SearchRecipePaginationParams extends PaginationStringParams {
  final String name;

  SearchRecipePaginationParams({
    required this.name,
    super.page,
    super.size,
  });

  @override
  SearchRecipePaginationParams copyWith({
    int? page,
    int? size,
    String? name,
  }) {
    return SearchRecipePaginationParams(
      name: name ?? this.name,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory SearchRecipePaginationParams.fromJson(Map<String, dynamic> json) =>
      _$SearchRecipePaginationParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchRecipePaginationParamsToJson(this);
}