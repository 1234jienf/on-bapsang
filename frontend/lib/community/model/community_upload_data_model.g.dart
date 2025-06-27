// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_upload_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityUploadDataModel _$CommunityUploadDataModelFromJson(
  Map<String, dynamic> json,
) => CommunityUploadDataModel(
  content: json['content'] as String,
  title: json['title'] as String,
  recipeId: json['recipeId'] as String,
  recipeTag: json['recipeTag'] as String,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
);

Map<String, dynamic> _$CommunityUploadDataModelToJson(
  CommunityUploadDataModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content,
  'recipeTag': instance.recipeTag,
  'recipeId': instance.recipeId,
  'x': instance.x,
  'y': instance.y,
};
