import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';

class MypageFixInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageFixInfoScreen';

  const MypageFixInfoScreen({super.key});

  @override
  ConsumerState<MypageFixInfoScreen> createState() => _MypageFixInfoScreenState();
}

class _MypageFixInfoScreenState extends ConsumerState<MypageFixInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        title: Text("mypage.setting_info".tr()),
        backgroundColor: Colors.white,
      ),
      child: Text('회원정보 수정 페이지')
    );
  }
}
