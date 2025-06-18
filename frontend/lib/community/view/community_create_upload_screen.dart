import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_app_bar.dart';
import 'package:frontend/community/model/community_upload_recipe_final_list_model.dart';
import 'package:photo_manager/photo_manager.dart';

import '../component/community_show_dialog.dart';
import '../model/community_upload_data_model.dart';
import '../provider/community_upload_provider.dart';

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
          appBar: CommunityAppBar(
            index: 2,
            title: '커뮤니티 올리기',
            next: '업로드',
            isFirst: false,
            isLast: true,
            function: () async {
              setState(() {
                isLoading = true;
              });
              final File? imageFile = await widget.data.imageFile.file;
              final model = CommunityUploadDataModel(
                content: contentController.text,
                title: titleController.text,
                recipeId: widget.data.recipeId,
                recipeTag: widget.data.recipeTag,
                x: widget.data.x,
                y: widget.data.y,
              );
              final response = await state.uploadPost(
                imagefile: imageFile!,
                data: model,
              );

              if (response.statusCode == 200) {
                if (context.mounted) {
                  communityShowDialog(context, true);
                }
              }
            },
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    _imageCreate(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width,
                    ),
                    _buildTag(context),
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
                        hintText: '제목은 최대 20자 가능합니다.',
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
                        hintText: '요리에 대한 소개를 해보세요.',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 5.0, top: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  FutureBuilder<Uint8List?> _imageCreate(double width, double height) {
    return FutureBuilder<Uint8List?>(
      future: widget.data.imageFile.thumbnailDataWithSize(
        ThumbnailSize(width.toInt(), height.toInt()),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: width,
            height: height,
          );
        } else if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(Icons.error),
          );
        } else {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTag(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tagWidth = 210.0;

    double adjustedX = widget.data.x - 12;

    // 왼쪽으로 넘어가는 경우
    if (adjustedX < 0) {
      adjustedX = 10;
    }

    // 오른쪽으로 넘어가는 경우
    if (adjustedX + tagWidth > screenWidth) {
      adjustedX = screenWidth - tagWidth - 10;
    }

    return Positioned(
      left: adjustedX,
      top: widget.data.y - 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
            height: 65,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Image.network(
                    widget.data.tagImage,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.data.recipeTag,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 연결선
          Container(
            width: 2,
            height: 20,
            color: Colors.grey,
            margin: EdgeInsets.only(left: (widget.data.x - adjustedX - 12)),
          ),

          // 버튼
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.only(left: (widget.data.x - adjustedX - 12)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
