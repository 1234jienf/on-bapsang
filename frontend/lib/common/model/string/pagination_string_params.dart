import 'package:json_annotation/json_annotation.dart';

part 'pagination_string_params.g.dart';

@JsonSerializable()
class PaginationStringParams {
  final String? after;
  final int? count;

  const PaginationStringParams({this.count, this.after});

  PaginationStringParams copyWith({
    final String? after,
    int? count,
  }) {
    return PaginationStringParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory PaginationStringParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationStringParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationStringParamsToJson(this);
}
