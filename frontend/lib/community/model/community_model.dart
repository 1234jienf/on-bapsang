import 'package:frontend/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_uitls.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel implements IModelWithId {
  @override
  final int intId;

  @override
  final String? stringId = null;

  @JsonKey(fromJson: DataUtils.pathToUrl,)
  final String imageUrl;

  final String title;
  final String name;
  final int scrapCount;
  final int commentCount;
  final String nickname;
  final String createdAt;

  CommunityModel({
    required this.title,
    required this.intId,
    required this.name,
    required this.imageUrl,
    required this.scrapCount,
    required this.commentCount,
    required this.nickname,
    required this.createdAt
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

}
