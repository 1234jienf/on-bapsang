import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/data_uitls.dart';
import 'community_model.dart';

part 'community_detail_model.g.dart';

@JsonSerializable()
class CommunityDetailModel extends CommunityModel implements IModelWithIntId {
  final String content;
  final bool scrapped;
  final String? profileImage;
  final int scrapCount;
  final int commentCount;
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
    required this.scrapCount,
    required this.commentCount,
    required this.createdAt,
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.nickname,
  });

  factory CommunityDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CommunityDetailModelToJson(this);
}