import 'package:json_annotation/json_annotation.dart';

part 'pagination_int_params.g.dart';

@JsonSerializable()
class PaginationIntParams {
  final int? afterId;
  final int? count;

  const PaginationIntParams({this.afterId, this.count});

  PaginationIntParams copyWith({
    int? afterId,
    int? count,
  }) {
    return PaginationIntParams(
      afterId: afterId ?? this.afterId,
      count: count ?? this.count,
    );
  }

  factory PaginationIntParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationIntParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationIntParamsToJson(this);
}
