import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/model/recipe_discounted_ingredient_model.dart';
import 'package:frontend/shopping/repository/shopping_cart_repository.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/colors.dart';
import '../../shopping/model/post_shopping_cart_model.dart';
import '../../shopping/view/shopping_cart_screen.dart';

class RecipeIngredientShoppingScreen extends ConsumerStatefulWidget {
  final List<DiscountedIngredient> discountedItems;

  const RecipeIngredientShoppingScreen({
    super.key,
    required this.discountedItems,
  });

  @override
  ConsumerState<RecipeIngredientShoppingScreen> createState() =>
      _ConsumerRecipeIngredientShoppingScreenState();
}

class _ConsumerRecipeIngredientShoppingScreenState
    extends ConsumerState<RecipeIngredientShoppingScreen> {
  // 각 상품 수량 저장
  late List<int> quantities;
  bool isLoading = false;

  int get totalPrice {
    int total = 0;
    for (int i = 0; i < widget.discountedItems.length; i++) {
      final item = widget.discountedItems[i];
      final quantity = quantities[i];
      total += item.salePrice * quantity;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    quantities = List.generate(widget.discountedItems.length, (index) => 1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFFEEEEEE),
              height: 8,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      if (isLoading) return;
                      isLoading = true;
                      final List<PostShoppingCartModel> model = List.generate(
                        widget.discountedItems.length,
                        (index) => PostShoppingCartModel(
                          ingredient_id:
                              widget.discountedItems[index].ingredientId,
                          quantity: quantities[index],
                        ),
                      );
                      final resp = await ref
                          .read(shoppingCartRepositoryProvider)
                          .postCart(model);
                      if (resp.statusCode == 200) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Timer(Duration(milliseconds: 800), () {
                                if (context.mounted) {
                                  context.pop();
                                  context.pushNamed(
                                    ShoppingCartScreen.routeName,
                                  );
                                }
                              });
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '장바구니 추가 완료',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Timer(Duration(milliseconds: 800), () {
                                if (context.mounted) {
                                  context.pop();
                                  context.pushNamed(
                                    ShoppingCartScreen.routeName,
                                  );
                                }
                              });
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '오류가 발생했습니다. 다시 시도해주세요',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                      isLoading = false;
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
                        '${NumberFormat('#,###').format(totalPrice)}원 주문하기',
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
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "recipe.buy_ingredients".tr(),
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      child: ListView.separated(
        itemCount: widget.discountedItems.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final item = widget.discountedItems[index];
          final quantity = quantities[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // 텍스트 정보
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.ingredient,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                item.discountRate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.salePrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 수량 버튼
                SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantities[index] > 1) {
                              quantities[index]--;
                            }
                          });
                        },
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (quantities[index] < 99) {
                              quantities[index]++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
