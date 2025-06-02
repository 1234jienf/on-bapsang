import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../component/sign_up_app_bar.dart';

class SignUpFoodPreferListScreen extends StatelessWidget {
  static String get routeName => 'SignUpFoodPreferListScreen';

  const SignUpFoodPreferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: SignUpAppBar(),
      child: Center(child: Text("preferfood")),
    );
  }
}
