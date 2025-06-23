import 'package:flutter/material.dart';
import 'package:frontend/recipe/view/recipe_category_list_screen.dart';
import 'package:frontend/shopping/view/shopping_root_screen.dart';
import 'package:go_router/go_router.dart';

class CategoryIcons extends StatelessWidget {
  final String type;

  const CategoryIcons({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // 카테고리 이름
    final List<Map<String, String>> categories = [
      {'image_url': 'asset/img/beef.png', 'name': '소고기'},
      {'image_url': 'asset/img/pork.png', 'name': '돼지고기'},
      {'image_url': 'asset/img/fish.png', 'name': '해물류'},
      {'image_url': 'asset/img/egg.png', 'name': '달걀/유제품'},
      {'image_url': 'asset/img/vege.png', 'name': '채소류'},
      {'image_url': 'asset/img/rice.png', 'name': '쌀'},
      {'image_url': 'asset/img/dried.png', 'name': '곡류'},
      {'image_url': 'asset/img/flour.png', 'name': '밀가루'},
      {'image_url': 'asset/img/so.png', 'name': '가공식품류'},
      {'image_url': 'asset/img/dried.png', 'name': '건어물류'},
      {'image_url': 'asset/img/etc.png', 'name': '기타'},
    ];

    return Column(
      children: List.generate((categories.length / 4).ceil(), (i) {
          return Column(
            children: [
              Row(
                children: List.generate(4, (j){
                  if (4 * i + j < categories.length) {
                    return Expanded(
                      child: CategoryIcon(
                          CategoryName: categories[4 * i + j]['name']!,
                          iconImage: categories[4 * i + j]['image_url']!,
                          type: type
                      ),
                    );
                  }
                  return Expanded(child: SizedBox());
                }),
              ),
              SizedBox(height: 15.0,)
            ],
          );
        })
    );
  }
}



Widget CategoryIcon({required String CategoryName, required String iconImage, required String type}) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        if (type == 'recipe') {
          context.pushNamed(
            RecipeCategoryListScreen.routeName,
            pathParameters: {'category': CategoryName},
          );
        }
        // 쇼핑은 우선 root로 다 보내기
        if (type == 'shopping') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShoppingRootScreen(),
            ),
          );
        }
      },
      child: Column(
        children: [
          Image.asset(
            iconImage,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          Text(CategoryName, style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}