import 'package:flutter/material.dart';
import 'package:frontend/shopping/model/ingredient_item_model.dart';
import 'package:frontend/shopping/view/shopping_detail/view/shopping_detail_screen.dart';
import 'package:go_router/go_router.dart';

class ShoppingCategoryListComponent extends StatefulWidget {
  final IngredientItemModel ingredientInfo;

  const ShoppingCategoryListComponent({super.key, required this.ingredientInfo});

  @override
  State<ShoppingCategoryListComponent> createState() => _ShoppingCategoryListComponentState();
}

class _ShoppingCategoryListComponentState extends State<ShoppingCategoryListComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: (){
        // 상세 페이지로 보내기
        context.pushNamed(ShoppingDetailScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.ingredientInfo.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // 텍스트 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.ingredientInfo.ingredient,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            widget.ingredientInfo.discountRate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.ingredientInfo.salePrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
      )
    );
  }
}
