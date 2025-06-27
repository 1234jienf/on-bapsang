import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/mypage/component/mypage_appbar.dart';
import 'package:frontend/mypage/provider/mypage_provider.dart';
import 'package:frontend/mypage/view/mypage_community_screen.dart';
import 'package:frontend/mypage/view/mypage_fix_info_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_community_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_recipe_screen.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class MypageRootScreen extends ConsumerStatefulWidget {
  static const routeName = 'MypageRootScreen';
  const MypageRootScreen({super.key});

  @override
  ConsumerState<MypageRootScreen> createState() => _MypageRootScreenState();
}

class _MypageRootScreenState extends ConsumerState<MypageRootScreen> {
  // 언어 옵션
  static const _languageOptions = [
    {'code': 'KO', 'label': '한국어'},
    {'code': 'EN', 'label': 'English'},
    {'code': 'ZH', 'label': '中文'},
    {'code': 'JA', 'label': '日本語'},
  ];

  bool _isLoading = false;

  /// 언어 선택 다이얼로그
  Future<String?> _showLanguageDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('mypage.setting_language'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        children: _languageOptions
            .map(
              (e) => SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, e['code']),
            child: Center(
                child: Text(e['label']!,
                    style: const TextStyle(fontSize: 16))),
          ),
        )
            .toList(),
      ),
    );
  }

  // ──────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mypageAsync = ref.watch(mypageInfoProvider);

    return Stack(
      children: [
        mypageAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('$err')),
          data: (info) => DefaultLayout(
            appBar: MypageAppbar(isImply: true, name: info.data.nickname),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _item('mypage.scrap_recipe', () {
                    context.pushNamed(MypageScrapRecipeScreen.routeName);
                  }),
                  _item('mypage.community', () {
                    context.pushNamed(MypageCommunityScreen.routeName);
                  }),
                  _item('mypage.scrap_community', () {
                    context.pushNamed(MypageScrapCommunityScreen.routeName);
                  }),
                  _item('mypage.setting_info', () {
                    context.pushNamed(MypageFixInfoScreen.routeName,
                        extra: info.data.toJson());
                  }),
                  _item('mypage.setting_language', () async {
                    final code = await _showLanguageDialog(context);
                    if (code == null) return;

                    setState(() => _isLoading = true);
                    try {
                      await ref.read(userProvider.notifier).patchLanguage(code);
                      await context.setLocale(Locale(code.toLowerCase()));
                      ref.invalidate(mypageInfoProvider);
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  }),
                  _item('mypage.withdraw', () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        title: Text('mypage.withdraw'.tr()),
                        content: Text('mypage.confirm_withdrawal'.tr()),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text('search.no'.tr())),
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text('search.yes'.tr())),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref.read(userProvider.notifier).withdraw();
                    }
                  }, textColor: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator())),
      ],
    );
  }

  /// 공통 리스트 아이템
  Widget _item(String label, VoidCallback onTap,
      {Color textColor = Colors.black}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Text(label.tr(),
                style: TextStyle(fontSize: 17, color: textColor)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
