import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';

import '../model/community_upload_recipe_list_model.dart';

class CommunityUploadRecipeComponent extends StatelessWidget {
  final String recipeId;
  final String name;
  final String imageUrl;

  const CommunityUploadRecipeComponent({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.recipeId,
  });

  factory CommunityUploadRecipeComponent.fromModel({
    required CommunityUploadRecipeListModel model,
  }) {
    return CommunityUploadRecipeComponent(
      imageUrl: model.imageUrl,
      name: model.name,
      recipeId: model.recipeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(imageUrl, fit: BoxFit.cover, width: 85, height: 85),
              const SizedBox(width: 16),
              SizedBox(
                width: 240,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16,),
          Divider(color: gray300, height: 1,),
        ],
      ),
    );
  }
}
