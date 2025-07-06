import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../model/community_next_upload_model.dart';
import 'community_create_recipe_tag_screen.dart';

class CommunityCreateScreen extends ConsumerStatefulWidget {
  static String get routeName => 'CommunityCreateScreen';
  final String recipe_name;

  const CommunityCreateScreen({super.key, required this.recipe_name});

  @override
  ConsumerState<CommunityCreateScreen> createState() =>
      _ConsumerCommunityCreateScreenState();
}

class _ConsumerCommunityCreateScreenState
    extends ConsumerState<CommunityCreateScreen> with WidgetsBindingObserver {
  List<AssetPathEntity> albums = <AssetPathEntity>[];
  List<AssetEntity> imageList = <AssetEntity>[];
  AssetEntity? selectedImage;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 100;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMorePhotos();
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    imageList.clear();
    albums.clear();
    selectedImage = null;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPhotos();
    }
  }

  Future<void> _loadPhotos() async {
    albums.clear();
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth || result == PermissionState.limited) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );
      _pagingPhotos();
    } else if (result == PermissionState.denied) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 외부 터치로 닫기 방지
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                '사진 접근 권한 필요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              content: Text('사진 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    context.pop();
                    // 설정 화면으로 이동
                    await PhotoManager.openSetting();
                    // 설정에서 돌아온 후 다시 권한 확인
                    // _recheckPermission();
                  },
                  child: Text('설정으로 이동'),
                ),
              ],
            ),
      );
  }

  Future<void> _pagingPhotos() async {
    if (albums.isEmpty) return;

    currentPage = 0;
    isLoading = false;
    hasMore = true;

    imageList = await albums.first.getAssetListPaged(
      page: currentPage,
      size: pageSize,
    );
    selectedImage = imageList.isNotEmpty ? imageList.first : null;
    setState(() {});
  }

  Future<void> _loadMorePhotos() async {
    if (isLoading || !hasMore || albums.isEmpty) return;

    isLoading = true;
    currentPage++;

    final nextPage = await albums.first.getAssetListPaged(
      page: currentPage,
      size: pageSize,
    );

    if (nextPage.isEmpty) {
      hasMore = false;
    } else {
      imageList.addAll(nextPage);
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CommunityAppBar(
        index: 0,
        title: "community.new_post".tr(),
        next: "common.next".tr(),
        isFirst: true,
        function: () async {
          if (selectedImage == null) return;

          final imageData = await selectedImage!.thumbnailDataWithSize(
            const ThumbnailSize(1024, 1024),
          );

          if (imageData == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("common.image_error".tr())),
              );
              return;
            }
          }

          final fileSizeInBytes = imageData!.length;
          final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

          if (fileSizeInMB > 10.0) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "common.image_error3".tr(
                      namedArgs: {"fileSize": fileSizeInMB.toStringAsFixed(2)},
                    ),
                  ),
                ),
              );
              return;
            }
          }

          if (context.mounted) {
            context.pushNamed(
              CommunityCreateRecipeTagScreen.routeName,
              extra: CommunityNextUploadModel(
                selectedImage: imageData,
                recipe_name: widget.recipe_name,
              ),
            );
          }
        },
      ),
      child: Column(
        children: [
          _content(context),
          const SizedBox(height: 8.0),
          Expanded(child: _imageSelectList(context)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final double mediaQuerySize = MediaQuery.of(context).size.width;
    return Container(
      width: mediaQuerySize,
      height: mediaQuerySize,
      color: Colors.grey,
      child:
          selectedImage == null
              ? Center(child: Text('이미지를 선택하세요'))
              : SelectedImageWidget(
                asset: selectedImage!,
                size: mediaQuerySize.round(),
              ),
    );
  }

  Widget _imageSelectList(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: imageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder:
          (_, index) => GridImageWidget(
            asset: imageList[index],
            selectedAsset: selectedImage,
            onTap: () {
              setState(() {
                selectedImage = imageList[index];
              });
            },
          ),
    );
  }
}

class SelectedImageWidget extends StatefulWidget {
  final AssetEntity asset;
  final int size;

  const SelectedImageWidget({
    super.key,
    required this.asset,
    required this.size,
  });

  @override
  State<SelectedImageWidget> createState() => _SelectedImageWidgetState();
}

class _SelectedImageWidgetState extends State<SelectedImageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.asset.thumbnailDataWithSize(
        ThumbnailSize(widget.size, widget.size),
      ),
      builder: (_, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child : CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        } else {
          return Container(color: Colors.grey[300]);
        }
      },
    );
  }
}

class GridImageWidget extends StatefulWidget {
  final AssetEntity asset;
  final AssetEntity? selectedAsset;
  final VoidCallback onTap;

  const GridImageWidget({
    super.key,
    required this.asset,
    required this.selectedAsset,
    required this.onTap,
  });

  @override
  State<GridImageWidget> createState() => _GridImageWidgetState();
}

class _GridImageWidgetState extends State<GridImageWidget> {
  dynamic cachedImage;

  @override
  void didUpdateWidget(GridImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id) {
      cachedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: FutureBuilder(
        future:
            cachedImage != null
                ? Future.value(cachedImage)
                : widget.asset.thumbnailDataWithSize(
                  const ThumbnailSize(200, 200),
                ),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            cachedImage = snapshot.data;
            return Opacity(
              opacity: widget.asset == widget.selectedAsset ? 0.4 : 1,
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            );
          } else {
            return Container(color: Colors.grey[300]);
          }
        },
      ),
    );
  }
}
