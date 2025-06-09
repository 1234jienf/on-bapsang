import 'package:json_annotation/json_annotation.dart';

part 'int_list_wrapper_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class IntListWrapperResponse<T> {
  final String message;
  final int status;
  final List<T> result;

  IntListWrapperResponse({
    required this.message,
    required this.status,
    required this.result,
  });

  factory IntListWrapperResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {

    return IntListWrapperResponse(
      message: json['message'],
      status: json['status'],
      // 제너릭 구조로 넣어줌
      result: List<T>.from(
        (json['data']['content'] as List<dynamic>).map((item) => fromJsonT(item as Map<String, dynamic>)),
      ),
    );
  }
}
