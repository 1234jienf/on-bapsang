import 'package:json_annotation/json_annotation.dart';

part 'int_data_wrapper_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class IntDataWrapperResponse<T> {
  final String message;
  final int status;
  final T result;

  IntDataWrapperResponse({
    required this.message,
    required this.status,
    required this.result,
  });

  factory IntDataWrapperResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {

    return IntDataWrapperResponse(
      message: json['message'],
      status: json['status'],
      // 제너릭 구조로 넣어줌
      result: fromJsonT(json['data']));
  }
}
