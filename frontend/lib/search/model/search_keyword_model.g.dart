// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_keyword_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchKeywordModel _$SearchKeywordModelFromJson(Map<String, dynamic> json) =>
    SearchKeywordModel(
      data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$SearchKeywordModelToJson(SearchKeywordModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
