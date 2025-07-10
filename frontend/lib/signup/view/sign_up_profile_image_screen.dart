import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/common/const/colors.dart';


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

// 기본 이미지
final List<String> sampleAssets = List.generate(7, (i) => 'asset/img/profile_sample${i + 1}.png',);

class _SignUpProfileImageScreenState extends State<SignUpProfileImageScreen> with WidgetsBindingObserver {
  List<AssetPathEntity> albums = <AssetPathEntity>[];
  List<AssetEntity> imageList = <AssetEntity>[];
  AssetEntity? selectedImage;

  final ScrollController _scrollController = ScrollController();

  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 30;
  String? selectedSamplePath;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
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
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false)
          ],
        ),
      );
      await _pagingPhotos();
    } else if (result == PermissionState.limited) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100)
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false)
          ]
        )
      );

      await _pagingPhotos();
      if (mounted) setState(() {});

    } else if (result == PermissionState.denied) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          context.tr("signup.image_auth"),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(context.tr("signup.image_auth_message")),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(context.tr("signup.no")),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              // 설정 화면으로 이동
              await PhotoManager.openSetting();
              // 설정에서 돌아온 후 다시 권한 확인
              // _recheckPermission();
            },
            child: Text(context.tr("signup.go_setting")),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPhotos();
    }
  }

  Future<void> _pagingPhotos() async {
    if (albums.isEmpty) return;

    currentPage = 0;
    isLoading = false;
    hasMore = true;

    final firstPage = await albums.first.getAssetListPaged(page: currentPage, size: pageSize);

    imageList = firstPage;
    selectedImage = imageList.isNotEmpty ? imageList.first : null;

    if (mounted) {
      setState(() {});
    }
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
    if (mounted) {
      setState(() {});
    }
  }

  void _selectImage(AssetEntity image) {
    if (!mounted) return;

    setState(() {
      selectedImage = image;
      selectedSamplePath = null;
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.tr("signup.profile_hint"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 15),
              _selectedImagePreview(width),
              const SizedBox(height: 15),

              SizedBox(
                height: width / 5,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sampleAssets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final path = sampleAssets[index];
                    final isSelected = path == selectedSamplePath;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSamplePath = path;
                          selectedImage = null;
                        });
                      },
                      child: Container(
                        width: width / 5,
                        height: width / 5,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

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
                  if (selectedSamplePath != null) {
                    // 바이트 로드
                    final bytes = await rootBundle.load(selectedSamplePath!);
                    // 임시 파일 생성
                    final dir  = await getTemporaryDirectory();
                    final file = File(p.join(dir.path, p.basename(selectedSamplePath!)));
                    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

                    widget.onComplete(file);
                    return;
                  }

                  if (selectedImage != null) {
                    final file = await selectedImage!.file;

                    if (file == null || !(await file.exists())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.tr('signup.no_image'))),
                      );
                      return;
                    }

                    final fileSizeInBytes = await file.length();
                    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                    if (fileSizeInMB > 15.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.tr(
                              'signup.image_size',
                              namedArgs: {
                                'size': fileSizeInMB.toStringAsFixed(2),
                              },
                            )
                          )
                        )
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
                  child: Center(
                    child: Text(
                      context.tr("signup.signup"),
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
    final size = width * 0.5;

    if (selectedSamplePath != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: PhotoView(
            key: ValueKey(selectedImage?.id ?? selectedSamplePath),
            imageProvider: AssetImage(selectedSamplePath!),
            initialScale: PhotoViewComputedScale.covered,
            basePosition: Alignment.center,
            minScale: PhotoViewComputedScale.covered,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            backgroundDecoration: const BoxDecoration(color: Colors.white),
          ),
        ),
      );
    }

    if (selectedImage != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: FutureBuilder<Uint8List?>(
            future: selectedImage!.thumbnailDataWithSize(ThumbnailSize(1024, 1024)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Container(
                  color: Colors.grey[200],
                  child:  Center(
                    child: Text(context.tr("signup.no_image")),
                  ),
                );
              }

              return PhotoView(
                key: ValueKey(selectedImage?.id ?? selectedSamplePath),
                imageProvider: MemoryImage(snapshot.data!),
                initialScale: PhotoViewComputedScale.covered,
                basePosition: Alignment.center,
                minScale: PhotoViewComputedScale.covered,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                backgroundDecoration: const BoxDecoration(color: Colors.white),
              );
            },
          ),
        ),
      );
    }


    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          color: gray200,
          child: Center(
            child: Text(
              context.tr("signup.select_image")
            ),
          ),
        ),
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
