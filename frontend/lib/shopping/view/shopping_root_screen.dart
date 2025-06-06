import 'package:flutter/material.dart';
import 'package:frontend/common/appbar/home_appbar.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/shopping/component/recipe_category.dart';

import '../../home/component/recipe_icon.dart';
import '../component/recipe_component.dart';

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
              height: 160,
              color: Colors.grey,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                RecipeIcon(),
                const SizedBox(height: 16.0),
              ]),
            ),
          ),
          _shoppingComponent(count: 10, title: '온밥 마켓 특가'),
          _shoppingComponent(count: 10, title: 'ㅇㅇㅇ 님에게 추천하는 상품'),
          RecipeComponent(price: 9900, percentage: 36),
          SliverToBoxAdapter(child: const SizedBox(height: 26)),
          RecipeCategory(percentage: 9900, price: 9900),
        ],
      ),
    );
  }

  SliverToBoxAdapter _shoppingComponent({
    required int count,
    required String title,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      "더보기 ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("asset/img/shopping_img.png"),
                          const SizedBox(height: 7),
                          Text('상품 타이틀', style: TextStyle(fontSize: 14)),
                          Row(
                            children: [
                              Text(
                                '26%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '9900원',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
