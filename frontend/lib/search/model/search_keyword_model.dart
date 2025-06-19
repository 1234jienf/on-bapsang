import 'package:json_annotation/json_annotation.dart';

part 'search_keyword_model.g.dart';

@JsonSerializable()
class SearchKeywordModel {
  final int status;
  final String message;
  final List<String> data;

  SearchKeywordModel({required this.data, required this.message, required this.status});

  factory SearchKeywordModel.fromJson(Map<String, dynamic> json) => _$SearchKeywordModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchKeywordModelToJson(this);

}