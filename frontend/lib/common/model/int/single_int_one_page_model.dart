import 'package:json_annotation/json_annotation.dart';

part 'single_int_one_page_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SingleIntOnePageModel<T> {
  final int status;
  final String message;
  final T data;

  SingleIntOnePageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SingleIntOnePageModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$SingleIntOnePageModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
      Object? Function(T value) toJsonT,
      ) =>
      _$SingleIntOnePageModelToJson(this, toJsonT);
}