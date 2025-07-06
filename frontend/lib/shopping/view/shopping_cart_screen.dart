import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../provider/shopping_cart_provider.dart';

class ShoppingCartScreen extends ConsumerStatefulWidget {
  static String get routeName => 'ShoppingCartScreen';

  const ShoppingCartScreen({super.key});

  @override
  ConsumerState<ShoppingCartScreen> createState() =>
      _ConsumerShoppingCartScreenState();
}

class _ConsumerShoppingCartScreenState
    extends ConsumerState<ShoppingCartScreen> {
  final ScrollController controller = ScrollController();

  List<bool> selectedItems = [];
  bool isAllSelected = true;

  void toggleAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      selectedItems = List.filled(selectedItems.length, isAllSelected);
    });
  }

  void toggleItem(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
      isAllSelected = selectedItems.every((isSelected) => isSelected);
    });
  }

  int cacluateTotalPrice() {
    final cartItems = ref.read(shoppingCartProvider);
    if (cartItems == null || selectedItems.isEmpty) return 0;

    int total = 0;
    for (
      int i = 0;
      i < cartItems.items.length && i < selectedItems.length;
      i++
    ) {
      if (selectedItems[i]) {
        total += cartItems.items[i].totalPrice;
      }
    }
    return total;
  }

  void _deleteItems(String title) async {
    final cartItems = ref.read(shoppingCartProvider);
    if (cartItems == null) return;

    final futures = <Future>[];

    for (int i = selectedItems.length - 1; i >= 0; i--) {
      if (selectedItems[i]) {
        final cartItemId = cartItems.items[i].cartItemId;
        futures.add(
          ref.read(shoppingCartProvider.notifier).deleteCart(cartItemId),
        );
      }
    }

    await Future.wait(futures);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Timer(Duration(milliseconds: 800), () {
            if (context.mounted) {
              context.pop();
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
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(shoppingCartProvider.notifier).getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(shoppingCartProvider);

    if (cartItems != null && selectedItems.length != cartItems.items.length) {
      selectedItems = List.filled(cartItems.items.length, true);
      isAllSelected = true;
    }

    final totalPrice = cacluateTotalPrice();

    return DefaultLayout(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '장바구니',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: SizedBox(
        height: 260,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 상품금액',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      cartItems == null
                          ? CircularProgressIndicator()
                          : Text(
                            '${NumberFormat('#,###').format(totalPrice)}원',
                            style: TextStyle(fontSize: 16.0),
                          ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 배송비',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('+0원', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 할인금액',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('- 0원', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '결제 금액',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      cartItems == null
                          ? CircularProgressIndicator()
                          : Text(
                            '${NumberFormat('#,###').format(totalPrice)}원',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      _deleteItems('주문 완료!');
                      context.goNamed('home');
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: gray900,
                      ),
                      alignment: Alignment.center,
                      child:
                          cartItems == null
                              ? CircularProgressIndicator()
                              : Text(
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
      child:
          cartItems == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                color: gray000,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {toggleAll();},
                                child: isAllSelected ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '전체 선택(${selectedItems.where((isSelected) => isSelected).length}/${cartItems.items.length})',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _deleteItems('장바구니 삭제 완료'),
                            child: Text(
                              '선택 삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xFFEEEEEE),
                      height: 8,
                      width: double.infinity,
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: cartItems.items.length,
                        itemBuilder: (context, index) {
                          final state = cartItems.items[index];
                          final isSelected =
                              index < selectedItems.length
                                  ? selectedItems[index]
                                  : true;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        toggleItem(index);
                                      },
                                      child:
                                          isSelected
                                              ? Icon(Icons.check_circle)
                                              : Icon(
                                                Icons.check_circle_outline,
                                              ),
                                    ),
                                    SizedBox(width: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        state.imageUrl,
                                        width: 85,
                                        height: 85,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    SizedBox(
                                      height: 85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.ingredientName,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  isSelected
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '26%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      isSelected
                                                          ? Colors.red
                                                          : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                NumberFormat(
                                                  '#,###',
                                                ).format(state.totalPrice),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                  color:
                                                      isSelected
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        shoppingCartProvider
                                                            .notifier,
                                                      )
                                                      .patchCart(
                                                        cartItems
                                                            .items[index]
                                                            .cartItemId,
                                                        cartItems
                                                            .items[index]
                                                            .quantity,
                                                        false,
                                                        cartItems
                                                            .items[index]
                                                            .ingredientId,
                                                      );
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color:
                                                      isSelected
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                cartItems.items[index].quantity
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      isSelected
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        shoppingCartProvider
                                                            .notifier,
                                                      )
                                                      .patchCart(
                                                        cartItems
                                                            .items[index]
                                                            .cartItemId,
                                                        cartItems
                                                            .items[index]
                                                            .quantity,
                                                        true,
                                                        cartItems
                                                            .items[index]
                                                            .ingredientId,
                                                      );
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      isSelected
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final resp = ref
                                        .read(shoppingCartProvider.notifier)
                                        .deleteCart(
                                          cartItems.items[index].cartItemId,
                                        );
                                    resp.then((res) {
                                      if (res.statusCode == 200) {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              Timer(
                                                Duration(milliseconds: 800),
                                                () {
                                                  if (context.mounted) {
                                                    context.pop();
                                                  }
                                                },
                                              );
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '장바구니 삭제 완료',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    });
                                  },
                                  child: Icon(Icons.close_outlined),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
