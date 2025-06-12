import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/view/recipe_category_list_screen.dart';
import 'package:frontend/recipe/view/recipe_root_screen.dart';
import 'package:go_router/go_router.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});
  static String get routeName => 'HomeMenuScreen';

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  @override
  Widget build(BuildContext context) {
    // 컴포넌트 사이 갭
    final double componentGap = 25.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 20.0;

    // 카테고리 이름
    final categories = ['쌀/곡류', '채소류', '가공식품류', '달걀/유제품', '고기류', '해물류', '과일류', '건어물류', '기타'];

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('전체 메뉴')
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: sideGap),
        child: Column(
          children: [
            SizedBox(height: componentGap,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '레시피',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: (){
                    context.goNamed(RecipeRootScreen.routeName);
                  },
                  child: Icon(Icons.chevron_right, size: 30,),
                )
              ],
            ),
            SizedBox(height: 20.0,),

            Column(
              children: List.generate(categories.length ~/5 + 1, (i) {
                return Column(
                  children: [
                    Row(
                      children: List.generate(5, (j){
                        if (5 * i + j < categories.length) {
                          return Expanded(
                            child: CategoryIcon(CategoryName: categories[5 * i + j], type: 'recipe'),
                          );
                        }
                        return Expanded(child: SizedBox());
                      }),
                    ),
                    SizedBox(height: 15.0,)
                  ],
                );
              })
            ),

            SizedBox(height: componentGap,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '쇼핑',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Icon(Icons.chevron_right, size: 30,),
                )
              ],
            ),
            SizedBox(height: 20.0,),

            Column(
                children: List.generate(categories.length ~/5 + 1, (i) {
                  return Column(
                    children: [
                      Row(
                        children: List.generate(5, (j){
                          if (5 * i + j < categories.length) {
                            return Expanded(
                              child: CategoryIcon(CategoryName: categories[5 * i + j], type: 'shopping'),
                            );
                          }
                          return Expanded(child: SizedBox());
                        }),
                      ),
                      SizedBox(height: 15.0,)
                    ],
                  );
                })
            ),

            SizedBox(height: componentGap,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '커뮤니티',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Icon(Icons.chevron_right, size: 30,),
                )
              ],
            ),

            SizedBox(height: componentGap,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '주변',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Icon(Icons.chevron_right, size: 30,),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}

Widget CategoryIcon({required String CategoryName, required String type}) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        if (type == 'recipe') {
          context.pushNamed(
            RecipeCategoryListScreen.routeName,
            pathParameters: {'category': CategoryName},
          );
        }

        // 쇼핑 라우터 달기
      },
      child: Column(
        children: [
          Icon(Icons.category_outlined, size: 32),
          Text(CategoryName, style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}