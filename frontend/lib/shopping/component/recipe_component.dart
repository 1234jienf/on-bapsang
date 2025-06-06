import 'package:flutter/material.dart';

class RecipeComponent extends StatefulWidget {
  final int price;
  final int percentage;
  const RecipeComponent({super.key, required this.price, required this.percentage});

  @override
  State<RecipeComponent> createState() => _RecipeComponentState();
}

class _RecipeComponentState extends State<RecipeComponent> {
  final items = List.generate(12, (index) => index);
  int selectedIndex = 0;
  final title_ = ['김치 두루치기', '감자탕'];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '레시피에 딱 맞는 재료',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color:
                          selectedIndex == index
                              ? Colors.orange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          title_[index],
                          style: TextStyle(
                            fontWeight:
                            selectedIndex == index
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate((items.length / 4).ceil(), (
                      pageIndex,
                      ) {
                    final start = pageIndex * 4;
                    final end = (start + 4).clamp(0, items.length);
                    final pageItems = items.sublist(start, end);

                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        children: [
                          Row(
                            children:
                            pageItems
                                .take(2)
                                .map((item) => _recipeCard())
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children:
                            pageItems
                                .skip(2)
                                .map((item) => _recipeCard())
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recipeCard() {
    return SizedBox(
      width: 260,
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "asset/img/shopping_img.png",
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('상품 타이틀', style: TextStyle(fontSize: 14)),
                  const Row(
                    children: [
                      Text(
                        '26%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
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
            ),
          ),
        ],
      ),
    );
  }
}
