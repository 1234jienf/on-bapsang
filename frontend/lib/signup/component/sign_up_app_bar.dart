import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/sign_up_language_provider.dart';

class SignUpAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final int step;

  const SignUpAppBar({super.key, required this.onBack, required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepTitleMap = {
      0: tr('signup.step0_title'), // "약관 동의"
      1: tr('signup.step1_title'), // "기본 정보 입력"
      2: tr('signup.step2_title'), // "선호 재료 선택"
      3: tr('signup.step3_title'), // "취향 선택"
      4: tr('signup.step4_title'), // "프로필 이미지 선택"
    };

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        stepTitleMap[step] ?? '',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
      ),
      leading: GestureDetector(
        onTap: onBack,
        child: Icon(Icons.arrow_back_ios_new_outlined, size: 23),
      ),
      actions: [PopupMenuButton(
        onSelected: (value) {
          final notifier = ref.read(signUpLanguageProvider.notifier);
          switch (value) {
            case 'kr':
              notifier.changeLanguage(SignUpLanguage.ko);
              context.setLocale(const Locale('ko'));
              break;
            case 'en':
              notifier.changeLanguage(SignUpLanguage.en);
              context.setLocale(const Locale('en'));
              break;
            case 'zh':
              notifier.changeLanguage(SignUpLanguage.zh);
              context.setLocale(const Locale('zh'));
              break;
            case 'jp':
              notifier.changeLanguage(SignUpLanguage.jp);
              context.setLocale(const Locale('ja'));
              break;
          }
        },
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'kr',
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('한국어', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'en',
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('English', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'zh',
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('中文', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'jp',
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('日本語', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
        icon: Icon(Icons.language_outlined, size: 26,),
      )],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
