import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/mypage/model/mypage_userInfo_model.dart';
import 'package:frontend/mypage/provider/mypage_provider.dart';
import 'package:frontend/user/model/user_patch_model.dart';
import 'package:frontend/user/provider/user_provider.dart';

// 이름이랑 인덱스 매핑용
extension OptionIdMapper on List<String> {
  int? idOf(String name) {
    final idx = indexOf(name);
    return idx >= 0 ? idx + 1 : null;
  }

  String? nameOf(int id) {
    final idx = id - 1;
    return (idx >= 0 && idx < length) ? this[idx] : null;
  }
}

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
  final ageController = TextEditingController();

  List<int> selectedIngredientIds = [];
  List<int> selectedTasteIds = [];
  List<int> selectedDishIds = [];

  final ingredientOptions = ['돼지고기', '닭고기', '소고기', '토마토', '양파', '오이', '양배추', '당근', '가지', '고추', '상추', '감자', '시금치'];
  final tasteOptions = ['매운맛', '짠맛', '단맛', '쓴맛', '신맛', '감칠맛'];
  final dishOptions = ['김치찌개', '된장찌개', '비빔밥', '불고기', '갈비', '삼계탕', '잡채', '김밥', '갈비탕', '칼국수'];

  String? nicknameError;
  String? ageError;
  String? ingredientError;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nicknameController.text = widget.info?.nickname ?? '';
    ageController.text = widget.info?.age.toString() ?? '';

    selectedIngredientIds = widget.info?.favoriteIngredients
        .map((e) => ingredientOptions.idOf(e))
        .whereType<int>()
        .toList() ??
        [];
    selectedTasteIds = widget.info?.favoriteTastes
        .map((e) => tasteOptions.idOf(e))
        .whereType<int>()
        .toList() ??
        [];
    selectedDishIds = widget.info?.favoriteDishes
        .map((e) => dishOptions.idOf(e))
        .whereType<int>()
        .toList() ??
        [];
  }

  @override
  void dispose() {
    nicknameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  String? _validateNickname(String v) {
    if (v.isEmpty) return '닉네임을 입력해주세요';
    if (v.length < 2 || v.length > 10) return '2~10자리로 입력해주세요';
    return null;
  }

  String? _validateAge(String v) {
    if (v.isEmpty) return '나이를 입력해주세요';
    final n = int.tryParse(v);
    if (n == null) return '숫자만 입력해주세요';
    if (n < 1 || n > 100) return '올바른 나이를 입력해주세요';
    return null;
  }

  String? _validateIds(List<int> ids) =>
      ids.isEmpty ? '적어도 하나를 선택해주세요' : null;

  bool _validateAll() {
    setState(() {
      nicknameError = _validateNickname(nicknameController.text);
      ageError = _validateAge(ageController.text);
      ingredientError = _validateIds(selectedIngredientIds);
    });
    return nicknameError == null &&
        ageError == null &&
        ingredientError == null;
  }

  // 저장 함수
  Future<void> _onSavePressed() async {
    if (!_validateAll()) return;

    setState(() => _isLoading = true);

    final patchData = UserPatchModel(
      nickname: nicknameController.text,
      age: int.parse(ageController.text),
      favoriteTasteIds: selectedTasteIds,
      favoriteDishIds: selectedDishIds,
      favoriteIngredientIds: selectedIngredientIds,
    );

    try {
      await ref
          .read(userProvider.notifier)
          .patchUserInfo(patchData);

      ref.invalidate(mypageInfoProvider);

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원 정보 수정에 실패했습니다.')),
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
                        title: '닉네임',
                        hintText: '2~10자리의 닉네임을 입력해주세요',
                        controller: nicknameController,
                        errorText: nicknameError,
                        onChanged: (_) {
                          if (nicknameError != null) {
                            setState(() => nicknameError =
                                _validateNickname(nicknameController.text));
                          }
                        },
                      ),
                      _buildTextField(
                        title: '나이',
                        hintText: '나이를 숫자로만 입력해주세요',
                        controller: ageController,
                        errorText: ageError,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          if (ageError != null) {
                            setState(() =>
                            ageError = _validateAge(ageController.text));
                          }
                        },
                      ),
                      _buildSelectField(
                        title: '좋아하는 재료',
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
                        title: '좋아하는 맛',
                        options: tasteOptions,
                        selectedIds: selectedTasteIds,
                      ),
                      _buildSelectField(
                        title: '좋아하는 요리',
                        options: dishOptions,
                        selectedIds: selectedDishIds,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? bottomInset : 32,
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
                    child: const Center(
                      child: Text(
                        '저장',
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
        Text(title,
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
        Text(title,
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
              label: Text(label),
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
