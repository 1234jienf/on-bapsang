import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/component/sign_up_app_bar.dart';
import 'package:frontend/signup/view/sign_up_food_prefer_list_screen.dart';

import '../component/next_bar.dart';

class SignUpRootScreen extends StatelessWidget {
  static String get routeName => 'SignUpRootScreen';

  const SignUpRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: SignUpAppBar(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            titleWithTextField('이메일', '이메일을 입력해주세요'),
            titleWithTextField('비밀번호', '8~30자리 영대 · 소문자, 숫자, 특수문자 조합'),
            titleWithTextField('비밀번호 확인', '8~30자리 영대 · 소문자, 숫자, 특수문자 조합'),
            titleWithTextField('닉네임', '자유롭게 설정'),
            titleWithTextField('나이', '본인의 나이를 적어주세요'),
            NextBar(
              title: '다음',
              routeName: SignUpFoodPreferListScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleWithTextField(String title, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.0),
              contentPadding: EdgeInsets.only(top: 10, bottom: 4),
              // ✅ 간격 줄이기
              isDense: true,
              // ✅ 높이 줄이는 추가 옵션
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 48.0),
      ],
    );
  }
}
