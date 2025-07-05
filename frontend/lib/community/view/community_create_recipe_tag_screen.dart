import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/model/community_next_upload_model.dart';
import 'package:frontend/community/model/community_upload_recipe_final_list_model.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/colors.dart';
import '../component/community_app_bar.dart';
import '../component/community_build_tag.dart';
import '../component/community_upload_recipe_component.dart';
import '../model/community_tag_position_model.dart';
import '../provider/community_upload_recipe_list_provider.dart';
import 'community_create_upload_screen.dart';

class CommunityCreateRecipeTagScreen extends ConsumerStatefulWidget {
  static String get routeName => 'CommunityCreateRecipeTagScreen';
  final CommunityNextUploadModel nextModel;

  const CommunityCreateRecipeTagScreen({super.key, required, required this.nextModel});

  @override
  ConsumerState<CommunityCreateRecipeTagScreen> createState() =>
      _ConsumerCommunityCreateRecipeTagScreenState();
}

class _ConsumerCommunityCreateRecipeTagScreenState
    extends ConsumerState<CommunityCreateRecipeTagScreen> {
  final ScrollController controller = ScrollController();
  List<CommunityTagPositionModel> tags = [];
  bool isTag = false;
  String keyword = '';
  late final CommunityUploadRecipeFinalListModel model;
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialKeyword = widget.nextModel.recipe_name;
    if (initialKeyword != "" && initialKeyword.isNotEmpty) {
      _searchController.text = initialKeyword;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(tagSearchKeywordProvider.notifier).state = initialKeyword;
        ref.watch(communityUploadRecipeListProvider(initialKeyword));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CommunityAppBar(
        index: 1,
        next: "common.next".tr(),
        title: "community.recipe_tag".tr(),
        isFirst: false,
        function: () async {
          if (tags.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "community.recipe_tag_notice".tr(),
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
          context.pushNamed(
            CommunityCreateUploadScreen.routeName,
            extra: CommunityUploadRecipeFinalListModel(
              tagImage: tags.first.imageUrl,
              recipeId: tags.first.recipeId,
              y: tags.first.y,
              x: tags.first.x,
              recipeTag: tags.first.name,
              imageFile: widget.nextModel.selectedImage,
            ),
          );
        },
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              _imageWithTags(),
              if (isTag)
                ...tags.map(
                  (tag) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          tag.imageUrl,
                          fit: BoxFit.cover,
                          width: 85,
                          height: 85,
                        ),
                        SizedBox(
                          width: 230,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tag.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tags.remove(tag);
                              isTag = false;
                            });
                          },
                          child: Icon(Icons.close_outlined, size: 25),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(
                    "community.recipe_tag_hint".tr(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageWithTags() {
    return GestureDetector(
      onTapDown: (details) async {
        if (isTag) {
          await showDialog(
            context: context,
            builder: (context) {
              Timer(Duration(milliseconds: 1000), () {
                if (context.mounted) {
                  context.pop();
                }
              });
              return _isTagshowTagDialog();
            },
          );
        } else {
          final localPosition = details.localPosition;
          _showTagDialog(localPosition);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            _imageCreate(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width,
            ),
            ...tags.map((tag) => CommunityBuildTag(tag: tag)),
          ],
        ),
      ),
    );
  }

  void _showTagDialog(Offset position) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final keyword = ref.watch(tagSearchKeywordProvider);
            final result = ref.watch(
              communityUploadRecipeListProvider(keyword),
            );
            return Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      onChanged: (value) {
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(Duration(milliseconds: 500), () {
                          if (value.isNotEmpty) {
                            ref.read(tagSearchKeywordProvider.notifier).state =
                                value;
                            ref.watch(communityUploadRecipeListProvider(value));
                          } else {
                            ref.read(tagSearchKeywordProvider.notifier).state =
                            '';
                          }
                        });
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "community.recipe_search_hint".tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),

                    Expanded(
                      child: keyword.isNotEmpty
                          ? result.when(
                        data: (recipes) {
                          if (recipes.isEmpty) {
                            return Center(child: Text("map.no_result".tr()));
                          }

                          return ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tags.add(
                                      CommunityTagPositionModel(
                                        x: position.dx,
                                        y: position.dy,
                                        name: recipe.name,
                                        imageUrl: recipe.imageUrl,
                                        recipeId: recipe.recipeId,
                                      ),
                                    );
                                    isTag = true;
                                  });
                                  context.pop();
                                },
                                child: CommunityUploadRecipeComponent.fromModel(
                                  model: recipe,
                                ),
                              );
                            },
                          );
                        },
                        error: (e, _) => Center(child: Text("common.error_message2".tr())),
                        loading: () => Center(child: CircularProgressIndicator()),
                      )
                          : Center(
                        child: Text(
                          "community.recipe_search_hint".tr(),
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _imageCreate(double width, double height) {
    return Image.memory(
      widget.nextModel.selectedImage,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  AlertDialog _isTagshowTagDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 30,
          child: Center(
            child: Text(
              textAlign : TextAlign.center,
              "community.recipe_tag_one".tr(),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
