import 'package:flutter/material.dart';
import 'package:frontend/common/appbar/home_appbar.dart';
import 'package:frontend/common/layout/default_layout.dart';

class ShoppingRootScreen extends StatefulWidget {
  const ShoppingRootScreen({super.key});

  @override
  State<ShoppingRootScreen> createState() => _ShoppingRootScreenState();
}

class _ShoppingRootScreenState extends State<ShoppingRootScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      appBar: const HomeAppbar(isImply: false),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: screenWidth,
              height: 90,
              color: Colors.grey,
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(child: Text('TODO: 콘텐츠 영역')),
          ),
        ],
      ),
    );
  }
}
