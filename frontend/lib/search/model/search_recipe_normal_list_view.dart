import 'package:json_annotation/json_annotation.dart';
import '../../common/model/string/pagination_string_params.dart';

part 'search_recipe_normal_list_view.g.dart';

@JsonSerializable()
class SearchRecipeNormalListView extends PaginationStringParams {
  final String name;

  SearchRecipeNormalListView({
    required this.name,
    super.page,
    super.size,
  });

  @override
  SearchRecipeNormalListView copyWith({
    int? page,
    int? size,
    String? name,
  }) {
    return SearchRecipeNormalListView(
      name: name ?? this.name,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory SearchRecipeNormalListView.fromJson(Map<String, dynamic> json) =>
      _$SearchRecipeNormalListViewFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchRecipeNormalListViewToJson(this);
}