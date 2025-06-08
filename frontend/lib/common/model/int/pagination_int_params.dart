import 'package:json_annotation/json_annotation.dart';

part 'pagination_int_params.g.dart';

@JsonSerializable()
class PaginationIntParams {
  final int? after;
  final int? count;

  const PaginationIntParams({this.after, this.count});

  PaginationIntParams copyWith({
    int? after,
    int? count,
  }) {
    return PaginationIntParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory PaginationIntParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationIntParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationIntParamsToJson(this);
}
