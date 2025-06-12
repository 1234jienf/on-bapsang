// api 어떤식으로 주는지 확인 필요..
import 'package:flutter/material.dart';

class RecipeShoppingScreen extends StatefulWidget {
  const RecipeShoppingScreen({super.key});

  @override
  State<RecipeShoppingScreen> createState() => _RecipeShoppingScreenState();
}

class _RecipeShoppingScreenState extends State<RecipeShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('레시피 - 재료 쇼핑 페이지');
  }
}
