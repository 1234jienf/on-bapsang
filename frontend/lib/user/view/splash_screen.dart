import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/go_router/provider/main_provider.dart';
import 'package:frontend/common/layout/default_layout.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routeName => 'SplashScreen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _ConsumerSplashScreenState();
}

class _ConsumerSplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(mainProvider).initApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'asset/img/splash_screen.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 220,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
