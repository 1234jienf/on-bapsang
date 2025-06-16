import 'package:flutter/material.dart';

class ShoppingRecipeCategory extends StatefulWidget {
  final int price;
  final int percentage;

  const ShoppingRecipeCategory({
    super.key,
    required this.percentage,
    required this.price,
  });

  @override
  State<ShoppingRecipeCategory> createState() => _ShoppingRecipeCategoryState();
}

class _ShoppingRecipeCategoryState extends State<ShoppingRecipeCategory> {
  int selectedIndex = 0;
  final List<String> categoryList = ['쌀/곡류', '채소류', '가공식품류', '달걀/유제품', '고기류'];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '카테고리별 인기 재료',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
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
                                    ? Colors.black
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            categoryList[index],
                            style: TextStyle(
                              color:
                                  selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight:
                                  selectedIndex == index
                                      ? FontWeight.w500
                                      : FontWeight.w200,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 10,
                    childAspectRatio: 175 / 235,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'asset/img/shopping_img.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 175,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('제품 타이틀'),
                              Row(
                                children: [
                                  Text(
                                    '39%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0,),
                                  Text(
                                    '9900원',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
