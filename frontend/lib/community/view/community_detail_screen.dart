import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class CommunityDetailScreen extends StatelessWidget {
  final String id;

  static String get routeName => 'CommunityDetailScreen';

  const CommunityDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      child: Center(child: Text('detail')),
    );
  }
}
