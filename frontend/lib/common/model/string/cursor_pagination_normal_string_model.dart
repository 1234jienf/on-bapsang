import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_normal_string_model.g.dart';

abstract class CursorStringNormalPaginationBase {}

class CursorStringNormalPaginationError extends CursorStringNormalPaginationBase {
  final String message;

  CursorStringNormalPaginationError({required this.message});
}

class CursorStringNormalPaginationLoading extends CursorStringNormalPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorPaginationNormalStringModel<T> extends CursorStringNormalPaginationBase {

  final CursorStringPaginationMeta meta;
  final List<T> data;

  CursorPaginationNormalStringModel({required this.meta, required this.data});

  CursorPaginationNormalStringModel copyWith({
    final CursorStringPaginationMeta? meta,
    final List<T>? data,
  }) {
    return CursorPaginationNormalStringModel<T>(
        meta: meta ?? this.meta, data: data ?? this.data);
  }

  factory CursorPaginationNormalStringModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$CursorPaginationNormalStringModelFromJson(json, fromJsonT);
}


@JsonSerializable()
class CursorStringPaginationMeta {
  final bool hasMore;
  final int currentPage;

  CursorStringPaginationMeta({required this.currentPage, required this.hasMore});

  CursorStringPaginationMeta copyWith({
    final int? currentPage,
    final bool? hasMore,
  }) {
    return CursorStringPaginationMeta(currentPage: currentPage ?? this.currentPage, hasMore : hasMore ?? this.hasMore);
  }

  factory CursorStringPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorStringPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$CursorStringPaginationMetaToJson(this);
}

class CursorStringNormalPaginationRefetching<T> extends CursorPaginationNormalStringModel<T> {
  CursorStringNormalPaginationRefetching({required super.meta, required super.data});
}

class CursorStringNormalPaginationFetchingMore<T> extends CursorPaginationNormalStringModel<T> {
  CursorStringNormalPaginationFetchingMore({required super.meta, required super.data});
}