import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shopping/model/shopping_items_model.dart';
import 'package:frontend/shopping/repository/shopping_cart_repository.dart';

final shoppingCartProvider =
    StateNotifierProvider<ShoppingCartNotifier, List<ShoppingItemsModel>>((
      ref,
    ) {
      final repo = ref.watch(shoppingCartRepositoryProvider);
      return ShoppingCartNotifier(repo);
    });

class ShoppingCartNotifier extends StateNotifier<List<ShoppingItemsModel>> {
  final ShoppingCartRepository repo;

  ShoppingCartNotifier(this.repo) : super([]);

  Future<void> loadCart() async {
    try {
      final response = await repo.getCart();
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}
