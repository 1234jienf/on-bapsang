import 'package:photo_manager/photo_manager.dart';

class CommunityUploadRecipeFinalListModel {
  final String recipeTag;
  final String recipeId;
  final double x;
  final double y;
  final AssetEntity imageFile;
  final String tagImage;

  CommunityUploadRecipeFinalListModel({
    required this.recipeId,
    required this.y,
    required this.x,
    required this.recipeTag,
    required this.imageFile,
    required this.tagImage,
  });
}
