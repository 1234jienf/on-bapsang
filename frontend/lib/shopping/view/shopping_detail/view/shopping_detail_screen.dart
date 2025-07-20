import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shopping/view/shopping_detail/view/shopping_detail_related_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../common/const/colors.dart';
import '../../../../common/divider/component_divider.dart';
import '../../../../recipe/component/recipe_ingredient_price_chart.dart';
import '../../../component/shopping_recipe_add_component.dart';
import '../../../provider/shopping_detail_provider.dart';

class ShoppingDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'ShoppingDetailScreen';
  final String id;

  const ShoppingDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ShoppingDetailScreen> createState() => _ConsumerShoppingDetailScreenState();
}

class _ConsumerShoppingDetailScreenState extends ConsumerState<ShoppingDetailScreen> {
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
    final state = ref.watch(shoppingDetailProvider(widget.id));
    // final ingredientTimeData = ref.watch(ingredientTimeSeriesProvider(widget.ingredientId));
    // final ingredientRegionData = ref.watch(ingredientRegionProvider(widget.ingredientId));

    return Scaffold(
      backgroundColor: Colors.white,
      body : state.when(data: <ShoppingDetailModel>(model) => _content(model), error: (error, stackTrace) => Center(child : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('오류 발생')],)), loading: () => Center(child: CircularProgressIndicator(),)),
      bottomNavigationBar: ShoppingRecipeAddComponent(),
    );
  }

  Widget _content(model) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Image.network(
                      model.shoppingIngredientInfo.image_url ?? 'asset/img/shopping_detail.png',
                      fit: BoxFit.cover,
                      height: 402,
                      width: 402,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 402,
                          width: 402,
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 64),
                        );
                      },
                    ),
                    Positioned(
                      top: 402 * 1 / 6,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.bookmark_border_outlined,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(Icons.upload),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_titleComponent(model)],
                  ),
                ),
              ),
              ComponentDivider(),
              _detailComponent(),
              _detailInformation(model),
              ComponentDivider(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    '관련 레시피',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ShoppingDetailRelatedScreen(),
              _comments(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _comments() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '문의',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '배송 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ),
            Divider(color: gray400),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '반품 및 교환 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ),
            Divider(color: gray400),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1:1 문의하기',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _titleComponent(model) {
    final priceString = model.shoppingIngredientInfo.price.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedPrice = '${NumberFormat('#,###').format(int.parse(priceString))}원';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.shoppingIngredientInfo.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Text(
        formattedPrice,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16.0),
        Text('원산지 : 국내산'),
        Text('판매 단위 : 1${model.shoppingIngredientInfo.unit}'),
        Text('중량/용량 : 300g'),
      ],
    );
  }

  Widget _detailInformation(model) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Text(
              '${model.shoppingIngredientInfo.name} 최근 시세',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 22.0,
            ),
            child: RecipeIngredientPriceChart(ingredientPriceDataList: [],),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Text(
              '제품 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 22.0,
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey),
              height: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 22.0,
              left: 22.0,
              right: 22.0,
            ),
            child: Container(
              height: 55,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffE5E5E5), width: 1.0),
              ),
              child: Text(
                textAlign: TextAlign.center,
                '펼쳐보기',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailComponent() {
    final List<String> component = ['상세정보', '관련 레시피'];
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
