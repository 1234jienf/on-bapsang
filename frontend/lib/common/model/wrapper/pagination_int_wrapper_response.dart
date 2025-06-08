import 'package:json_annotation/json_annotation.dart';

import '../int/cursor_pagination_int_model.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationIntWrapperResponse<T> {
  final String message;
  final int status;
  final CursorIntPagination<T> result;

  PaginationIntWrapperResponse({
    required this.message,
    required this.status,
    required this.result,
  });

  factory PaginationIntWrapperResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    final data = json['data'];

    return PaginationIntWrapperResponse(
      message: json['message'],
      status: json['status'],
      result: CursorIntPagination<T>(
        meta: CursorIntPaginationMeta(
          totalElements: data['totalElements'],
          last: data['last'],
        ),
        data: (data['content'] as List).map(fromJsonT).toList(),
      ),
    );
  }
}