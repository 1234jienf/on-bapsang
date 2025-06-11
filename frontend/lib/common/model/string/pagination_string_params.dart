import 'package:json_annotation/json_annotation.dart';

part 'pagination_string_params.g.dart';

@JsonSerializable()
class PaginationStringParams {
  final int? page;
  final int? size;

  const PaginationStringParams({this.page, this.size});

  PaginationStringParams copyWith({
    final int? page,
    final int? size,
  }) {
    return PaginationStringParams(
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  factory PaginationStringParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationStringParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationStringParamsToJson(this);
}
