import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../user/view/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'SplashScreen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [LoginScreen()],
        ),
      ),
    );
  }
}
