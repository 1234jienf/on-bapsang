import 'package:json_annotation/json_annotation.dart';
import '../../common/model/string/pagination_string_params.dart';

part 'search_recipe_pagination_params.g.dart';

@JsonSerializable()
class SearchRecipePaginationParams extends PaginationStringParams {
  final String food_name;

  SearchRecipePaginationParams({
    required this.food_name,
    super.page,
    super.size,
  });

  @override
  SearchRecipePaginationParams copyWith({
    int? page,
    int? size,
    String? food_name,
  }) {
    return SearchRecipePaginationParams(
      food_name: food_name ?? this.food_name,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory SearchRecipePaginationParams.fromJson(Map<String, dynamic> json) =>
      _$SearchRecipePaginationParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchRecipePaginationParamsToJson(this);
}