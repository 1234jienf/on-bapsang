import 'package:json_annotation/json_annotation.dart';

part 'pagination_string_params.g.dart';

@JsonSerializable()
class PaginationStringParams {
  final String? stringAfterId;
  final int? count;

  const PaginationStringParams({this.count, this.stringAfterId});

  PaginationStringParams copyWith({
    final String? stringAfterId,
    int? count,
  }) {
    return PaginationStringParams(
      stringAfterId: stringAfterId ?? this.stringAfterId,
      count: count ?? this.count,
    );
  }

  factory PaginationStringParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationStringParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationStringParamsToJson(this);
}
