import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class CommunityRootScreen extends StatelessWidget {
  const CommunityRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('community'),));
  }
}
