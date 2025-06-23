import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_recipe/component/search_recipe_card.dart';
import 'package:go_router/go_router.dart';

import '../../../common/component/pagination_string_list_view.dart';
import '../../../recipe/view/recipe_detail_screen.dart';
import '../../model/search_recipe_model.dart';
import '../../provider/search_provider.dart';
import '../provider/search_filter_apply_provider.dart';
import '../provider/search_filter_provider.dart';

class SearchRecipeScreen extends ConsumerWidget {
  final String name;

  const SearchRecipeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appliedFilters = ref.watch(searchFilterApplyProvider);
    final hasFilters = appliedFilters.isNotEmpty;

    return DefaultLayout(
      child:
          hasFilters
              ? _buildFilteredView(ref)
              : PaginationStringListView<SearchRecipeModel>(
                fetchCount: 100,
                provider: searchProvider(name),
                itemBuilder: <SearchRecipeModel>(_, index, model) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        RecipeDetailScreen.routeName,
                        pathParameters: {
                          'id': model.recipe_id.toString(),
                        },
                      );
                    },
                    child: SearchRecipeCard.fromModel(model: model),
                  );
                },
              ),
    );
  }

  Widget _buildFilteredView(WidgetRef ref) {
    final filteredData = ref.watch(searchFilterProvider(name));

    return Column(
      children: [
        // 필터 결과 정보
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text('${filteredData.length}개 결과'),
              Spacer(),
              TextButton(
                onPressed: () {
                  ref.read(searchFilterApplyProvider.notifier).clear();
                },
                child: Text('필터 초기화'),
              ),
            ],
          ),
        ),

        // 필터된 결과 리스트
        Expanded(
          child:
              filteredData.isEmpty
                  ? Center(child: Text('조건에 맞는 레시피가 없습니다.'))
                  : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RecipeDetailScreen.routeName,
                            pathParameters: {
                              'id': filteredData[index].recipe_id.toString(),
                            },
                          );
                        },
                        child: SearchRecipeCard.fromModel(
                          model: filteredData[index],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
