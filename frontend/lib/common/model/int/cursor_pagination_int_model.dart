import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_int_model.g.dart';

abstract class CursorIntPaginationBase {}

class CursorIntPaginationError extends CursorIntPaginationBase {
  final String message;

  CursorIntPaginationError({required this.message});
}

class CursorIntPaginationLoading extends CursorIntPaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class CursorIntPagination<T> extends CursorIntPaginationBase {

  final int status;
  final String message;
  final CursorIntPaginationData<T> data;

  CursorIntPagination(
      {required this.data, required this.status, required this.message});

  CursorIntPagination<T> copyWith({
    final int? status,
    final String? message,
    final CursorIntPaginationData<T>? data
  }) {
    return CursorIntPagination<T>(
        status : status ?? this.status, data: data ?? this.data, message : message ?? this.message);
  }

  factory CursorIntPagination.fromJson(Map<String, dynamic> json,
      T Function(Object? json) fromJsonT) =>
      _$CursorIntPaginationFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
      Object? Function(T value) toJsonT,
      ) =>
      _$CursorIntPaginationToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class CursorIntPaginationData<T> {
  final List<T> content;
  final CursorIntPaginationPageable? pageable;
  final bool? last;

  CursorIntPaginationData({required this.content, this.pageable, this.last});

  CursorIntPaginationData<T> copyWith({
    final List<T>? content,
    final CursorIntPaginationPageable? pageable,
    final bool? last,
  }) {
    return CursorIntPaginationData<T>(
        content: content ?? this.content, pageable: pageable ?? this.pageable, last : last ?? this.last);
  }

  factory CursorIntPaginationData.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$CursorIntPaginationDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
      Object? Function(T value) toJsonT,
      ) =>
      _$CursorIntPaginationDataToJson(this, toJsonT);
}

@JsonSerializable()
class CursorIntPaginationPageable {
  final int pageNumber;

  CursorIntPaginationPageable({required this.pageNumber});

  CursorIntPaginationPageable copyWith({
    final int? pageNumber,
}) {
    return CursorIntPaginationPageable(pageNumber : pageNumber ?? this.pageNumber);
  }

  factory CursorIntPaginationPageable.fromJson(Map<String, dynamic> json) => _$CursorIntPaginationPageableFromJson(json);

  Map<String, dynamic> toJson() => _$CursorIntPaginationPageableToJson(this);
}

class CursorIntPaginationRefetching<T> extends CursorIntPagination<T> {
  CursorIntPaginationRefetching({required super.status, required super.data, required super.message});
}

class CursorIntPaginationFetchingMore<T> extends CursorIntPagination<T> {
  CursorIntPaginationFetchingMore({required super.status, required super.data, required super.message});
}