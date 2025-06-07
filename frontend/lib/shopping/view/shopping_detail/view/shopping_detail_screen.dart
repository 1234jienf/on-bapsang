import 'package:flutter/material.dart';

import '../../../../common/divider/component_divider.dart';

class ShoppingDetailScreen extends StatefulWidget {
  static String get routeName => 'ShoppingDetailScreen';

  const ShoppingDetailScreen({super.key});

  @override
  State<ShoppingDetailScreen> createState() => _ShoppingDetailScreenState();
}

class _ShoppingDetailScreenState extends State<ShoppingDetailScreen> {
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
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Image.asset(
            'asset/img/shopping_detail.png',
            fit: BoxFit.cover,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_titleComponent()],
            ),
          ),
        ),
        ComponentDivider(),
      ],
    );
  }

  Widget _titleComponent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '콩나물 300g',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Text(
          '1,490원',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16.0),
        Text('원산지 : 국내산'),
        Text('판매 단위 : 1봉'),
        Text('중량/용량 : 300g'),
      ],
    );
  }
}
