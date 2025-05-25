import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class ShoppingRootScreen extends StatelessWidget {
  const ShoppingRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('shopping'),));
  }
}
