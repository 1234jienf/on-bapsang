import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';

class ShoppingPayment extends StatelessWidget {
  static String get routeName => 'ShoppingPayment';

  const ShoppingPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '주문/결제',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: gray000,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _componentDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 26.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주문 고객 정보',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16.0),
                  _textBox('주문자', '이름을 입력해주세요'),
                  const SizedBox(height: 16.0),
                  _textBox('전화번호', '전화번호를 입력해주세요'),
                ],
              ),
            ),
            Container(
              color: Color(0xFFEEEEEE),
              height: 8,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 26.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '배송지 정보',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Icon(Icons.check_box_outlined, color: gray600),
                      const SizedBox(width: 8.0),
                      Text('주문 고객 정보와 동일'),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  _textBox('받는분', '이름을 입력해주세요'),
                  const SizedBox(height: 16.0),
                  _textBox('전화번호', '전화번호를 입력해주세요'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '주소',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        width: 270,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 127,
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: gray000,
                                  border: OutlineInputBorder(),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: gray300,
                                      width: 1.0,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: gray600,
                                      width: 1.5,
                                    ),
                                  ),

                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                onSubmitted: (value) {},
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 127,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: gray700),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '우편번호 검색',
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 0),
                      SizedBox(
                        height: 40,
                        width: 270,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: gray000,
                            border: OutlineInputBorder(),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),

                              borderSide: BorderSide(
                                color: gray300,
                                width: 1.0,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: gray600,
                                width: 1.5,
                              ),
                            ),

                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _textBox('상세주소', '상세 주소를 입력해주세요'),
                  const SizedBox(height: 26.0),
                  Row(
                    children: [
                      Icon(Icons.check_box),
                      const SizedBox(width: 10.0),
                      Text('기본 배송지로 등록', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
            ),
            _componentDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 26.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 수단',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(height: 200, color: gray200),
                ],
              ),
            ),
            _componentDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 26.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 금액',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 26.0),
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
                      Text('123,000원', style: TextStyle(fontSize: 16.0)),
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
                      Text('-12,000원', style: TextStyle(fontSize: 16.0)),
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
                      Text(
                        '123,000원',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: gray900,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '123,000원 주문하기',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: gray000,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _componentDivider() {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 8,
      width: double.infinity,
    );
  }

  Widget _textBox(String title, String? explain) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
        ),
        SizedBox(
          height: 40,
          width: 270,
          child: TextField(
            decoration: InputDecoration(
              hintText: explain,
              hintStyle: TextStyle(color: gray600, fontSize: 16.0),
              filled: true,
              fillColor: gray000,
              border: OutlineInputBorder(),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),

                borderSide: BorderSide(color: gray300, width: 1.0),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: gray600, width: 1.5),
              ),

              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onSubmitted: (value) {},
          ),
        ),
      ],
    );
  }
}
