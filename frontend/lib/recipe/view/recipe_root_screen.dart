import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class RecipeRootScreen extends StatelessWidget {
  const RecipeRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('recipe'),));
  }
}
