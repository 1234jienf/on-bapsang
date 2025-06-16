import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key, required this.count});

  final int count;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return _renderComponent();
  }

  Column _renderComponent() {
    return Column(
      children: List.generate(widget.count ~/ 2, (index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (_) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      RecipeDetailScreen.routeName,
                      pathParameters: {'id': '7016813'},
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.grey),
                        width: 175.0,
                        height: 100.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 7.0,),
                            Text(
                              '메뉴명',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Text('9900원, 30분, 초보', style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                            Text('스크랩 수 ${widget.count}', style: TextStyle(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
            ),
            const SizedBox(height: 20.0),
          ],
        );
      }),
    );
  }
}
