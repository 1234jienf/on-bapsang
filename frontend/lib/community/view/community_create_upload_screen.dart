import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_app_bar.dart';
import 'package:frontend/community/component/community_build_tag.dart';
import 'package:frontend/community/model/community_upload_recipe_final_list_model.dart';

import '../../common/const/colors.dart';
import '../component/community_show_dialog.dart';
import '../model/community_tag_position_model.dart';
import '../model/community_upload_data_model.dart';
import '../provider/community_upload_provider.dart';
import '../provider/community_upload_recipe_list_provider.dart';

class CommunityCreateUploadScreen extends ConsumerStatefulWidget {
  final CommunityUploadRecipeFinalListModel data;

  static String get routeName => 'CommunityCreateUploadScreen';

  const CommunityCreateUploadScreen({super.key, required this.data});

  @override
  ConsumerState<CommunityCreateUploadScreen> createState() =>
      _ConsumerCommunityCreateUploadScreenState();
}

class _ConsumerCommunityCreateUploadScreenState
    extends ConsumerState<CommunityCreateUploadScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late final CommunityUploadDataModel model;
  bool isLoading = false;
  bool isShowTag = true;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(communityUploadProvider);
    return Stack(
      children: [
        DefaultLayout(
          resizeToAvoidBottomInset: true,
          appBar: CommunityAppBar(
            index: 2,
            title: "community.new_post".tr(),
            next: "community.upload".tr(),
            isFirst: false,
            isLast: true,
            function: () async {
              if (titleController.text.isEmpty ||
                  contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "community.post_error_hint".tr(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: gray400,
                    duration: Duration(seconds: 1),
                  ),
                );
                return;
              }
              setState(() {
                isLoading = true;
              });
              final Uint8List? imageFile = widget.data.imageFile;
              final model = CommunityUploadDataModel(
                content: contentController.text,
                title: titleController.text,
                recipeId: widget.data.recipeId,
                recipeTag: widget.data.recipeTag,
                x: widget.data.x,
                y: widget.data.y,
              );

              final response = await state.uploadPost(
                imageData: imageFile!,
                data: model,
              );
              if (response.statusCode == 200) {
                if (context.mounted) {
                  communityShowDialog(context, ref, true, "community.post_success".tr());
                  ref.read(tagSearchKeywordProvider.notifier).state = '';
                }
              } else {
                if (context.mounted) {
                  setState(() {
                    isLoading = false;
                    communityShowDialog(
                      context,
                      ref,
                      true,
                      "common.error_message2".tr(),
                    );
                  });
                  ref.read(tagSearchKeywordProvider.notifier).state = '';
                }
              }
            },
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {setState(() {
                            isShowTag = !isShowTag;
                          });},
                          child: _imageCreate(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.width,
                          ),
                        ),
                        CommunityBuildTag(
                          tag: CommunityTagPositionModel(
                            x: widget.data.x,
                            y: widget.data.y,
                            name: widget.data.recipeTag,
                            imageUrl: widget.data.tagImage,
                            recipeId: widget.data.recipeId.toString(),
                          ),
                          isVisible: isShowTag,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "community.post_title_hint".tr(),
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 5.0,
                              top: 26.0,
                              bottom: 10.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            hintText: "community.post_hint".tr(),
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 5.0,
                              top: 10.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withAlpha((255 * 0.4).round()),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _imageCreate(double width, double height) {
    return Image.memory(
      widget.data.imageFile,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

}
