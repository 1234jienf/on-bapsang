import 'package:json_annotation/json_annotation.dart';

part 'recipe_category_pagination_params_model.g.dart';

@JsonSerializable()
class CategoryPaginationIntParams {
  final String category;
  final int? page;
  final int? size;

  const CategoryPaginationIntParams({
    required this.category,
    this.page,
    this.size,
  });

  factory CategoryPaginationIntParams.fromJson(Map<String, dynamic> json) =>
      _$CategoryPaginationIntParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryPaginationIntParamsToJson(this);
}
