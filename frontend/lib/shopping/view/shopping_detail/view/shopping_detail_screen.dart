import 'package:flutter/material.dart';
import 'package:frontend/shopping/view/shopping_detail/view/shopping_detail_related_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/divider/component_divider.dart';

class ShoppingDetailScreen extends StatefulWidget {
  static String get routeName => 'ShoppingDetailScreen';

  const ShoppingDetailScreen({super.key});

  @override
  State<ShoppingDetailScreen> createState() => _ShoppingDetailScreenState();
}

class _ShoppingDetailScreenState extends State<ShoppingDetailScreen> {
  final ScrollController controller = ScrollController();
  int selectedIndex = 0;

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
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'asset/img/shopping_detail.png',
                  fit: BoxFit.cover,
                  height: 402,
                  width: 402,
                ),
                Positioned(
                  top: 402 * 1 / 6,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {context.pop();},
                            child: Icon(Icons.arrow_back_ios_new_outlined),
                          ),
                          Row(children: [GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.bookmark_border_outlined,),
                          ),
                            const SizedBox(width: 10.0,),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.upload),
                            ),],)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
          _detailComponent(),
          ComponentDivider(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '관련 레시피',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          ShoppingDetailRelatedScreen(),
        ],
      ),
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

  Widget _detailComponent() {
    final List<String> component = ['상세정보', '리뷰', '관련 레시피'];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(component.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border:
                      selectedIndex == index
                          ? Border(
                            bottom: BorderSide(color: Colors.black, width: 3.0),
                          )
                          : null, // 선택되지 않으면 border 없음
                ),
                child: Text(
                  component[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.black : Colors.grey,
                    fontSize: 18,
                    fontWeight:
                        selectedIndex == index
                            ? FontWeight.w700
                            : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
