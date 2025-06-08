import 'package:json_annotation/json_annotation.dart';

part 'pagination_string_params.g.dart';

@JsonSerializable()
class PaginationStringParams {
  final String? afterId;
  final int? count;

  const PaginationStringParams({this.count, this.afterId});

  PaginationStringParams copyWith({
    final String? afterId,
    int? count,
  }) {
    return PaginationStringParams(
      afterId: afterId ?? this.afterId,
      count: count ?? this.count,
    );
  }

  factory PaginationStringParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationStringParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationStringParamsToJson(this);
}
