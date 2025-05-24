import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../../common/appbar/home_appbar.dart';
import '../component/recipe_card.dart';
import '../component/recipe_icon.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      renderAppBar: HomeAppbar(),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // TODO : 검색
                Container(
                  width: 360,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // TODO : AI 배너
                Container(
                  width: 360,
                  height: 90,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Recipe Icon
                RecipeIcon(),
                const SizedBox(height: 20),

                // 인기 레시피
                Text(
                  '인기 레시피',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                RecipeCard(count: 10,),
                const SizedBox(height: 20),

                // 제철재료 레시피
                Text(
                  '제철재료 레시피',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                // 추천 레시피
                Text(
                  '추천 레시피',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                RecipeCard(count: 10,),
                const SizedBox(height: 20),
                Text(
                  '커뮤니티',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
