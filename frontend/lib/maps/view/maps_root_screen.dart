import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class MapsRootScreen extends StatelessWidget {
  const MapsRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Center(child: Text('maps'),));
  }
}
