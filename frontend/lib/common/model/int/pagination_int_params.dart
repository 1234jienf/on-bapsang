import 'package:json_annotation/json_annotation.dart';

part 'pagination_int_params.g.dart';

@JsonSerializable()
class PaginationIntParams {
  final int? page;
  final int? size;

  const PaginationIntParams({this.size, this.page});

  PaginationIntParams copyWith({
    int? page,
    int? size,
  }) {
    return PaginationIntParams(
      size: size ?? this.size,
      page: page ?? this.page,
    );
  }

  factory PaginationIntParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationIntParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationIntParamsToJson(this);
}
