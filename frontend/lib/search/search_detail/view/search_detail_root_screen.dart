import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../component/search_detail_app_bar.dart';

class SearchDetailRootScreen extends StatelessWidget {
  static String get routeName => 'SearchDetailRootScreen';
  SearchDetailRootScreen({super.key});
  final List<String> tabs = ['종류 선택', '조리법 선택', '식재료 선택', '식재료 선택', '식재료 선택'];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(appBar: SearchDetailAppBar(title : '종류 선택'),child: Center(child: Text("ro")),);
  }
}
