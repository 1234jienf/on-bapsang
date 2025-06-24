import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import 'community_create_recipe_tag_screen.dart';

class CommunityCreateScreen extends ConsumerStatefulWidget {
  static String get routeName => 'CommunityCreateScreen';

  const CommunityCreateScreen({super.key});

  @override
  ConsumerState<CommunityCreateScreen> createState() =>
      _ConsumerCommunityCreateScreenState();
}

class _ConsumerCommunityCreateScreenState
    extends ConsumerState<CommunityCreateScreen> {
  List<AssetPathEntity> albums = <AssetPathEntity>[];
  List<AssetEntity> imageList = <AssetEntity>[];
  AssetEntity? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  void dispose() {
    imageList.clear();
    albums.clear();
    selectedImage = null;
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
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
    } else {}
  }

  Future<void> _pagingPhotos() async {
    if (albums.isEmpty) return;
    imageList = await albums.first.getAssetListPaged(page: 0, size: 100);
    selectedImage = imageList.isNotEmpty ? imageList.first : null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CommunityAppBar(
        index: 0,
        title: '사진 올리기',
        next: '다음',
        isFirst: true,
        function: () async {
          context.pushNamed(CommunityCreateRecipeTagScreen.routeName, extra: selectedImage);
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
        if (snapshot.hasData && snapshot.data != null) {
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
