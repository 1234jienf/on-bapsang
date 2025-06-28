import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/appbar/home_appbar.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/shopping/component/shopping_recipe_category.dart';
import 'package:frontend/shopping/view/shopping_detail/view/shopping_detail_screen.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/colors.dart';
import '../../home/component/recipe_icon.dart';
import '../../mypage/provider/mypage_provider.dart';
import '../component/shopping_recipe_component.dart';

class ShoppingRootScreen extends ConsumerStatefulWidget {
  const ShoppingRootScreen({super.key});

  @override
  ConsumerState<ShoppingRootScreen> createState() => _ConsumerShoppingRootScreenState();
}

class _ConsumerShoppingRootScreenState extends ConsumerState<ShoppingRootScreen> {
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
    final state = ref.watch(mypageInfoProvider);
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
          _shoppingComponent(count: 10, title: '${state.value?.data.nickname} 님에게 추천하는 상품'),
          ShoppingRecipeComponent(price: 9900, percentage: 36),
          SliverToBoxAdapter(child: const SizedBox(height: 26)),
          ShoppingRecipeCategory(percentage: 9900, price: 9900),
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
        child: GestureDetector(
          onTap: () {
            context.pushNamed(ShoppingDetailScreen.routeName);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Image.asset("asset/img/shopping_img.png"),

                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showAddComponent(context);
                                    },
                                    child: Icon(
                                      Icons.add_circle_outline_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),

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
      ),
    );
  }

  void _showAddComponent(BuildContext context) {
    int count = 1;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 2 / 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 26.0, left: 26.0, top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '제품 구매',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: gray200),
                              height: 80,
                              width: 80,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('상품명'), Text('상품 설명')],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(color: gray400),
                        const SizedBox(height: 8),
                        Text(
                          '[상품명] 130g * 12개입',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '26%',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '9,900원',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (count > 1) {
                                        count--;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.remove),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (count < 98) {
                                        count++;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Timer(Duration(milliseconds: 1000), () {
                              if (context.mounted) {
                                context.pop();
                              }
                            });

                            return AlertDialog(
                              backgroundColor: gray000,
                              alignment: Alignment.center,
                              contentPadding: const EdgeInsets.all(16.0),
                              content: Container(
                                width: 300,
                                height: 80,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  '장바구니에 상품이 추가되었습니다',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          },
                        );
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: gray900,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '장바구니 담기',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: gray000,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
