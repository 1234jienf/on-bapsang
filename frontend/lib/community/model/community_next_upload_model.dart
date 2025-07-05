import 'dart:typed_data';

class CommunityNextUploadModel {
  final String recipe_name;
  final Uint8List selectedImage;

  CommunityNextUploadModel({
    required this.recipe_name,
    required this.selectedImage,
  });
}
