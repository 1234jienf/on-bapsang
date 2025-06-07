import 'package:json_annotation/json_annotation.dart';
import 'community_model.dart';

part 'community_detail_model.g.dart';

@JsonSerializable()
class CommunityDetailModel extends CommunityModel {
  final String content;
  final bool scrapped;
  final String? profileImage;
  final double x;
  final double y;

  CommunityDetailModel({
    required this.content,
    required this.scrapped,
    required this.profileImage,
    required this.x,
    required this.y,
    required super.intId,
    required super.title,
    required super.imageUrl,
    required super.nickname,
    required super.scrapCount,
    required super.commentCount,
    required super.createdAt, required super.name,
  });

  factory CommunityDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CommunityDetailModelToJson(this);
}