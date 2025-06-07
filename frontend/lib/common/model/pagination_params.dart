import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final int? intAfterId;
  final String? stringAfterId;
  final int? count;

  const PaginationParams({this.intAfterId, this.count, this.stringAfterId});

  PaginationParams copyWith({
    int? intAfterId,
    final String? stringAfterId,
    int? count,
  }) {
    return PaginationParams(
      intAfterId: intAfterId ?? this.intAfterId,
      stringAfterId: stringAfterId ?? this.stringAfterId,
      count: count ?? this.count,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
