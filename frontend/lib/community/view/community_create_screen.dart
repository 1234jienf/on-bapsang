import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class CommunityCreateScreen extends StatelessWidget {
  static String get routeName => 'CommunityCreateScreen';

  const CommunityCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('create'),));
  }
}
