import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/component/sign_up_app_bar.dart';

import '../component/next_bar.dart';

class SignUpRootScreen extends StatelessWidget {
  static String get routeName => 'SignUpRootScreen';

  const SignUpRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: SignUpAppBar(),
      child: Column(children: [NextBar(title: '다음',)]),
    );
  }
}
