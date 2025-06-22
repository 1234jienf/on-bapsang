import 'package:flutter/material.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';
import 'package:frontend/recipe/view/recipe_ingredient_price_screen.dart';
import 'package:frontend/recipe/data/data_loader.dart';
import 'package:frontend/recipe/view/recipe_ingredient_shopping_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String id;
  static String get routeName => 'RecipeDetailScreen';

  const RecipeDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  final ScrollController controller = ScrollController();
  bool? isScrapped;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeDetailProvider(int.parse(widget.id)));

    // 사진, 텍스트 사이 갭
    final double titleTextGap = 10.0;
    // 컴포넌트 사이 갭
    final double componentGap = 20.0;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            recipeAsync.when(
              loading: () => IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){},),
              error: (err, stack) => IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){},),
              data: (recipe) {

                isScrapped ??= recipe.scrapped;

                return IconButton(
                  icon: isScrapped! ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
                  onPressed: () async {
                    try {
                      if (isScrapped!) {
                        await ref.read(recipeRepositoryProvider).cancelRecipeScrap(recipe.id);
                        setState(() {
                          isScrapped = false;
                        });
                      } else {
                        await ref.read(recipeRepositoryProvider).recipeScrap(recipe.id);
                        setState(() {
                          isScrapped = true;
                        });
                      }
                    } catch (e) {
                      print('스크랩 실패: $e');
                    }
                  },
                );
              }
            )
          ],
        ),
        body: recipeAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('$err')),
          data: (recipe) => CustomScrollView(
            controller: controller,
            slivers: [
              // 레시피 이미지
              SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  height: 402,
                  child: Image.network(
                    recipe.image_url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.error, size: 50),
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: componentGap),
                    // 레시피 제목
                    Text(
                      recipe.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: componentGap),

                    // 레시피 설명(review, descriptions?)
                    Text(
                      recipe.review,
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    SizedBox(height: componentGap),

                    // 레시피 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        infoWidget(title: '분량', content: recipe.portion),
                        infoWidget(title: '시간', content: recipe.time == 'nan' ? '-' : recipe.time),
                        infoWidget(title: '난이도', content: recipe.difficulty),
                      ],
                    ),
                    SizedBox(height: componentGap),
                  ]),
                ),
              ),

              // 구분선
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),

              // 재료
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: componentGap),
                    const Text(
                      '재료',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: titleTextGap),

                    ...List.generate(recipe.ingredients.length * 2 - 1, (index) {
                      if (index.isEven) {
                        final i = index ~/ 2;
                        final ingredient = recipe.ingredients[i];
                        return gradientWidget(
                          context: context,
                          ingredientId: ingredient.ingredientId,
                          name: ingredient.name,
                          quantity: ingredient.amount,
                        );
                      } else {
                        // 구분선
                        return Container(
                          height: 1.0,
                          decoration: const BoxDecoration(color: Colors.black12),
                        );
                      }
                    }),

                    SizedBox(height: componentGap),
                  ]),
                ),
              ),

              // 구분선
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),

              // 조리순서
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: componentGap),
                    Text(
                      '조리순서',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: componentGap),
                    ...List.generate(recipe.instruction.length, (index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 60.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    recipe.instruction[index],
                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    })
                  ]),
                ),
              ),

              // 구분선 3
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),

              // 후기
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: componentGap),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '레시피 후기 ${recipe.reviewCount}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                            onPressed: (){
                              // 커뮤니티 글 쓰는 페이지로 보내주기
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('리뷰쓰기')
                        )
                      ],
                    ),
                    SizedBox(height: componentGap),

                    recipe.reviews.isNotEmpty
                        ? Column(
                      children: List.generate((recipe.reviews.length + 2) ~/ 3, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: List.generate(3, (j) {
                              int index = i * 3 + j;

                              if (index >= recipe.reviews.length) {
                                return Expanded(child: SizedBox());
                              }

                              final imageUrl = recipe.reviews[index].imageUrl;

                              print(imageUrl);

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.error, size: 50),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('아직 작성된 리뷰가 없습니다.'),
                    ),

                    SizedBox(height: titleTextGap),

                    recipe.reviewCount > 9
                    ? InkWell(
                      onTap: (){
                        // 여기서 커뮤니티 페이지로 넘겨야 함.
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1.0)),
                        child: Center(child: Text('더보기')),
                      ),
                    )
                    : SizedBox(height: 10.0,),
                    SizedBox(height: componentGap),
                  ]),
                ),
              ),
            ],
          ),
        ),
      persistentFooterButtons: recipeAsync.when (
        loading: () => [],
        error: (err, stack) => [],
        data: (recipe) => [
          Container(
              width: double.infinity,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeIngredientShoppingScreen()
                      )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '재료 구매하기/재료보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          )
        ],
      )
    );
  }
}


Widget infoWidget({
  required String title,
  required String content
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black45),
      ),
      SizedBox(width: 6.0,),
      Text(
        content,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      SizedBox(width: 12.0,),
    ],
  );
}

Widget gradientWidget({
  required BuildContext context,
  required int ingredientId,
  required String name,
  required String quantity,
}) {
  return FutureBuilder(
    future: getMarketItemIdFromIngredient(ingredientId),
    builder: (context, AsyncSnapshot<int?> snapshot) {
      final marketItemId = snapshot.data;

      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (marketItemId == null) {
        return SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                quantity,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }

      return GestureDetector(
        onTap: (){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
            ),
            builder: (context) {
              return RecipeIngredientPriceScreen(
                ingredientName: name,
                ingredientId: marketItemId,
              );
            });
        },
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16, color: Colors.blue), // 시세 있는 애들은 어떻게 표시?
              ),
              Text(
                quantity,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );

    });
  }