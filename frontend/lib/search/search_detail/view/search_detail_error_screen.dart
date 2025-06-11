import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../component/search_app_bar.dart';

class SearchDetailErrorScreen extends StatelessWidget {
  static String get routeName => 'SearchDetailErrorScreen';
  const SearchDetailErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(appBar : SearchAppBar(), child: Center(child: Text('검색된 레시피가 없습니다')));
  }
}
