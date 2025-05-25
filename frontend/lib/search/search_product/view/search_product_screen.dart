import 'package:flutter/material.dart';

import '../../../common/layout/default_layout.dart';

class SearchProductScreen extends StatelessWidget {
  const SearchProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('product'),));
  }
}
