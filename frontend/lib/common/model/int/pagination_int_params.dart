import 'package:json_annotation/json_annotation.dart';

part 'pagination_int_params.g.dart';

@JsonSerializable()
class PaginationIntParams {
  final int? intAfterId;
  final int? count;

  const PaginationIntParams({this.intAfterId, this.count});

  PaginationIntParams copyWith({
    int? intAfterId,
    int? count,
  }) {
    return PaginationIntParams(
      intAfterId: intAfterId ?? this.intAfterId,
      count: count ?? this.count,
    );
  }

  factory PaginationIntParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationIntParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationIntParamsToJson(this);
}
