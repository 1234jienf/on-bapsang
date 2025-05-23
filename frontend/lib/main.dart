import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/view/root_tab.dart';

void main() {
  runApp(ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final router = ref.watch(routerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: DefaultLayout(child: _thisPage())),
    );
  }
}

Widget _thisPage() {
  return Scaffold(body: RootTab());
}
