import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/colors.dart';

class ShoppingRecipeAddComponent extends StatefulWidget {
  final Function? function;

  const ShoppingRecipeAddComponent({super.key, this.function});

  @override
  State<ShoppingRecipeAddComponent> createState() => _ShoppingRecipeAddComponentState();
}

class _ShoppingRecipeAddComponentState extends State<ShoppingRecipeAddComponent> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 16.0, right: 16.0),
      child: GestureDetector(
        onTap: () {
          _showAddComponent(context);
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
            '구매하기',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: gray000,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showAddComponent(BuildContext context) {
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
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 26),
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
                              Future.delayed(Duration(seconds: 1), () {
                                if (context.mounted) Navigator.of(context).pop();
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

                          context.pop();
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
