import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/mypage/view/mypage_root_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/mypage/model/mypage_userInfo_model.dart';
import 'package:frontend/mypage/provider/mypage_provider.dart';
import 'package:frontend/user/model/user_patch_model.dart';
import 'package:frontend/user/provider/user_provider.dart';

// 회원 정보 수정
class MypageFixInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageFixInfoScreen';
  final MypageUserInfoModel? info;

  const MypageFixInfoScreen({super.key, this.info});

  @override
  ConsumerState<MypageFixInfoScreen> createState() =>
      _MypageFixInfoScreenState();
}

class _MypageFixInfoScreenState extends ConsumerState<MypageFixInfoScreen> {
  final nicknameController = TextEditingController();

  List<int> selectedIngredientIds = [];
  List<int> selectedTasteIds = [];
  List<int> selectedDishIds = [];

  final ingredientOptions = [
    'common.ingredients.pork',
    'common.ingredients.chicken',
    'common.ingredients.beef',
    'common.ingredients.tomato',
    'common.ingredients.onion',
    'common.ingredients.cucumber',
    'common.ingredients.cabbage',
    'common.ingredients.carrot',
    'common.ingredients.eggplant',
    'common.ingredients.chili_pepper',
    'common.ingredients.lettuce',
    'common.ingredients.potato',
    'common.ingredients.spinach',
  ];
  final tasteOptions = [
    'common.tastes.spicy',
    'common.tastes.salty',
    'common.tastes.sweet',
    'common.tastes.bitter',
    'common.tastes.sour',
    'common.tastes.umami',
  ];
  final dishOptions = [
    'common.dishes.kimchi_stew',
    'common.dishes.soybean_paste_stew',
    'common.dishes.bibimbap',
    'common.dishes.bulgogi',
    'common.dishes.galbi',
    'common.dishes.samgyetang',
    'common.dishes.japchae',
    'common.dishes.gimbap',
    'common.dishes.galbitang',
    'common.dishes.kalguksu',
  ];

  String? nicknameError;
  String? ingredientError;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nicknameController.text = widget.info?.nickname ?? '';

    // print(widget.info?.favoriteIngredients);
    // print(widget.info?.favoriteDishes);
    // print(widget.info?.favoriteTastes);

    selectedIngredientIds = widget.info?.favoriteIngredients ?? [];
    selectedTasteIds = widget.info?.favoriteTastes ?? [];
    selectedDishIds = widget.info?.favoriteDishes ?? [];
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  String? _validateNickname(String v) {
    if (v.isEmpty) return "mypage.nicknameRequired".tr();
    if (v.length < 2 || v.length > 10) return "mypage.nicknameLength".tr();
    return null;
  }

  String? _validateIds(List<int> ids) =>
      ids.isEmpty ? "mypage.selectAtLeastOne".tr() : null;

  bool _validateAll() {
    setState(() {
      nicknameError = _validateNickname(nicknameController.text);
      ingredientError = _validateIds(selectedIngredientIds);
    });
    return nicknameError == null &&
        ingredientError == null;
  }

  // 저장 함수
  Future<void> _onSavePressed() async {
    if (!_validateAll()) return;

    setState(() => _isLoading = true);

    final patchData = UserPatchModel(
      nickname: nicknameController.text,
      age: 30,
      favoriteTasteIds: selectedTasteIds,
      favoriteDishIds: selectedDishIds,
      favoriteIngredientIds: selectedIngredientIds,
    );

    try {
      await ref
          .read(userProvider.notifier)
          .patchUserInfo(patchData);

      ref.invalidate(mypageInfoProvider);

      if (mounted) {
        context.goNamed(MypageRootScreen.routeName);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("mypage.patch_failed".tr())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        _buildMainScaffold(bottomInset),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  /// 메인 UI
  Widget _buildMainScaffold(double bottomInset) {
    return DefaultLayout(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('mypage.setting_info'.tr()),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildTextField(
                        title: "common.nickname",
                        hintText: "mypage.enterNickname".tr(),
                        controller: nicknameController,
                        errorText: nicknameError,
                        onChanged: (_) {
                          if (nicknameError != null) {
                            setState(() => nicknameError =
                                _validateNickname(nicknameController.text));
                          }
                        },
                      ),
                      _buildSelectField(
                        title: "common.favoriteIngredient",
                        options: ingredientOptions,
                        selectedIds: selectedIngredientIds,
                        errorText: ingredientError,
                        onChanged: () {
                          if (ingredientError != null) {
                            setState(() => ingredientError =
                                _validateIds(selectedIngredientIds));
                          }
                        },
                      ),
                      _buildSelectField(
                        title: "common.favoriteTaste",
                        options: tasteOptions,
                        selectedIds: selectedTasteIds,
                      ),
                      _buildSelectField(
                        title: "common.favoriteDishes",
                        options: dishOptions,
                        selectedIds: selectedDishIds,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? bottomInset : 10,
                  top: 8,
                ),
                child: GestureDetector(
                  onTap: _isLoading ? null : _onSavePressed,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "mypage.save".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr(),
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.blue,
                  width: 2),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSelectField({
    required String title,
    required List<String> options,
    required List<int> selectedIds,
    String? errorText,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr(),
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 7,
          runSpacing: 2,
          children: options.asMap().entries.map((entry) {
            final idx = entry.key; // 0-based
            final label = entry.value;
            final id = idx + 1; // 1-based
            final isSelected = selectedIds.contains(id);

            return ChoiceChip(
              label: Text(label.tr()),
              selected: isSelected,
              onSelected: (sel) {
                setState(() {
                  if (sel) {
                    if (!selectedIds.contains(id)) selectedIds.add(id);
                  } else {
                    selectedIds.remove(id);
                  }
                  onChanged?.call();
                });
              },
              selectedColor: primaryColor,
              backgroundColor: Colors.white,
              showCheckmark: false,
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(errorText,
                style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
