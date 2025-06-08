import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel implements IModelWithIntId {
  @override
  final int id;
  final String imageUrl;
  final String title;
  final String nickname;


  CommunityModel({
    required this.title,
    // ignore: non_constant_identifier_names
    required this.id,
    required this.imageUrl,
    required this.nickname,

  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) => _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

}
