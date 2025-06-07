import 'package:flutter/material.dart';

class ComponentDivider extends StatelessWidget {
  const ComponentDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xFFEEEEEE),
        width: MediaQuery.of(context).size.width,
        height: 8,
      ),
    );
  }
}
