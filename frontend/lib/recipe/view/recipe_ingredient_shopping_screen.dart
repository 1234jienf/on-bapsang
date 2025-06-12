import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class RecipeIngredientShoppingScreen extends StatefulWidget {
  const RecipeIngredientShoppingScreen({super.key});

  @override
  State<RecipeIngredientShoppingScreen> createState() => _RecipeIngredientShoppingScreenState();
}

class _RecipeIngredientShoppingScreenState extends State<RecipeIngredientShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('재료 보기'),
      ),
      child: Text('재료쇼핑(디자인 나오면 할 예정.....)')
    );
  }
}
