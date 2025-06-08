import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/data_uitls.dart';
import 'community_model.dart';

part 'community_detail_model.g.dart';

@JsonSerializable()
class CommunityDetailModel extends CommunityModel {
  final String content;
  final bool scrapped;
  final String? profileImage;
  final double x;
  final double y;
  @JsonKey(fromJson: DataUtils.dateTimeFromJson)
  final DateTime createdAt;

  CommunityDetailModel({
    required this.content,
    required this.scrapped,
    required this.profileImage,
    required this.x,
    required this.y,
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.nickname,
    required this.createdAt
  });

  factory CommunityDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CommunityDetailModelToJson(this);
}