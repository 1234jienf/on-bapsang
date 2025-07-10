import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/shopping/component/shopping_category_list_component.dart';
import 'package:frontend/shopping/data/data_loader.dart';
import 'package:frontend/shopping/model/ingredient_item_model.dart';

// 매핑용
const Map<String, String> koCategoryToKey = {
  '소고기':     'common.category.beef',
  '돼지고기':   'common.category.pork',
  '해물류':     'common.category.seafood',
  '달걀/유제품': 'common.category.egg_dairy',
  '채소류':     'common.category.vegetables',
  '쌀':        'common.category.rice',
  '곡류':       'common.category.grains',
  '밀가루':     'common.category.flour',
  '가공식품류':  'common.category.processed',
  '건어물류':    'common.category.dried',
  '기타':       'common.category.etc',
};

// 카테고리별로 재료 리스트
class ShoppingCategoryListScreen extends ConsumerStatefulWidget {
  final String categoryName;
  static String get routeName => 'ShoppingCategoryListScreen';
  const ShoppingCategoryListScreen({super.key, required this.categoryName});

  @override
  ConsumerState<ShoppingCategoryListScreen> createState() => _ShoppingCategoryListScreenState();
}

class _ShoppingCategoryListScreenState extends ConsumerState<ShoppingCategoryListScreen> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final key = koCategoryToKey[widget.categoryName];
    final title = key != null ? key.tr() : widget.categoryName;

    return DefaultLayout(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      child: FutureBuilder<List<IngredientItemModel>>(
        future: loadIngredientItemsByCategory(widget.categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('common.error_message'.tr()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("shopping.no_category".tr()));
          }

          final ingredients = snapshot.data!;
          return ListView.builder(
            controller: controller,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredientInfo = ingredients[index];
              return ShoppingCategoryListComponent(ingredientInfo: ingredientInfo);
            },
          );
        },
      )
    );
  }
}
