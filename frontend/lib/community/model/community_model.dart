import 'package:json_annotation/json_annotation.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel {
  final String id;
  final String name;
  final int scrapCount;
  final int commentCount;
  final String nickname;
  final String imageUrl;

  CommunityModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.scrapCount,
    required this.commentCount,
    required this.nickname,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

}
