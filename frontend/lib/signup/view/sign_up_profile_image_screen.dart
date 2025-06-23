import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

class SignUpProfileImageScreen extends StatefulWidget {
  final Function(File) onComplete;
  final SignupRequest? initialData;

  const SignUpProfileImageScreen({
    super.key,
    required this.onComplete,
    required this.initialData,
  });

  @override
  State<SignUpProfileImageScreen> createState() => _SignUpProfileImageScreenState();
}

class _SignUpProfileImageScreenState extends State<SignUpProfileImageScreen> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> imageList = [];
  AssetEntity? selectedImage;

  final ScrollController _scrollController = ScrollController();

  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 30;

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
        ),
      );
      await _pagingPhotos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진 라이브러리 권한이 필요합니다.')),
      );
    }
  }

  Future<void> _pagingPhotos() async {
    if (albums.isEmpty) return;

    currentPage = 0;
    isLoading = false;
    hasMore = true;

    final firstPage =
    await albums.first.getAssetListPaged(page: currentPage, size: pageSize);

    imageList = firstPage;
    selectedImage = imageList.isNotEmpty ? imageList.first : null;

    setState(() {});
  }

  Future<void> _loadMorePhotos() async {
    if (isLoading || !hasMore || albums.isEmpty) return;

    isLoading = true;
    currentPage++;

    final nextPage =
    await albums.first.getAssetListPaged(page: currentPage, size: pageSize);

    if (nextPage.isEmpty) {
      hasMore = false;
    } else {
      imageList.addAll(nextPage);
    }

    isLoading = false;
    setState(() {});
  }

  void _selectImage(AssetEntity image) {
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '프로필 이미지',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 15),
              _selectedImagePreview(width),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  itemCount: imageList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) => GridImageWidget(
                    asset: imageList[index],
                    selectedAsset: selectedImage,
                    onTap: () => _selectImage(imageList[index]),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  if (selectedImage != null) {
                    final file = await selectedImage!.file;

                    if (file == null || !(await file.exists())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('이미지 파일을 불러올 수 없습니다.')),
                      );
                      return;
                    }

                    final fileSizeInBytes = await file.length();
                    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                    if (fileSizeInMB > 15.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '이미지 용량이 ${fileSizeInMB.toStringAsFixed(2)}MB입니다. 15MB 이하로 줄여주세요.'),
                        ),
                      );
                      return;
                    }

                    widget.onComplete(file);
                  }
                },
                child: Container(
                  width: width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: bottomInset > 0 ? bottomInset : 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedImagePreview(double width) {
    return Center(
      child: Container(
        width: width * 0.5,
        height: width * 0.5,
        color: Colors.grey,
        child: selectedImage == null
            ? const Center(child: Text('이미지를 선택하세요'))
            : SelectedImageWidget(
            asset: selectedImage!, size: (width * 0.5).round()),
      ),
    );
  }
}

class SelectedImageWidget extends StatelessWidget {
  final AssetEntity asset;
  final int size;

  const SelectedImageWidget({
    super.key,
    required this.asset,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover, gaplessPlayback: true);
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
        future: cachedImage != null
            ? Future.value(cachedImage)
            : widget.asset.thumbnailDataWithSize(const ThumbnailSize(100, 100)),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            cachedImage = snapshot.data;
            return Opacity(
              opacity: widget.asset == widget.selectedAsset ? 0.4 : 1,
              child: Image.memory(snapshot.data!,
                  fit: BoxFit.cover, gaplessPlayback: true),
            );
          } else {
            return Container(color: Colors.grey[300]);
          }
        },
      ),
    );
  }
}
