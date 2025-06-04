import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class HomeCartScreen extends StatefulWidget {
  static String get routeName => 'HomeCartScreen';

  const HomeCartScreen({super.key});

  @override
  State<HomeCartScreen> createState() => _HomeCartScreenState();
}

class _HomeCartScreenState extends State<HomeCartScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('장바구니')
      ),
      child: Text('장바구니')
    );
  }
}
