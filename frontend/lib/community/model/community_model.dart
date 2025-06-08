import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_uitls.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel implements IModelWithIntId {
  @override
  final int id;

  @JsonKey(fromJson: DataUtils.pathToUrl,)
  final String imageUrl;

  @JsonKey(fromJson: DataUtils.dateTimeFromJson)
  final DateTime createdAt;

  final String title;
  final int scrapCount;
  final int commentCount;
  final String nickname;


  CommunityModel({
    required this.title,
    // ignore: non_constant_identifier_names
    required this.id,
    required this.imageUrl,
    required this.scrapCount,
    required this.commentCount,
    required this.nickname,
    required this.createdAt,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

}
