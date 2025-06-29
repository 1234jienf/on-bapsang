import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/shopping/repository/shopping_cart_repository.dart';

import '../model/shopping_cart_get_model.dart';

final shoppingCartProvider =
    StateNotifierProvider<ShoppingCartNotifier, ShoppingCartGetModel?>((ref) {
      final repo = ref.watch(shoppingCartRepositoryProvider);
      return ShoppingCartNotifier(repo);
    });

class ShoppingCartNotifier extends StateNotifier<ShoppingCartGetModel?> {
  final ShoppingCartRepository repo;

  ShoppingCartNotifier(this.repo) : super(null);

  Future<void> getCart() async {
    try {
      final response = await repo.getCart();
      state = ShoppingCartGetModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Timer? timer;
  void patchCart(int cartItemId, int quantity, bool isPlus, int ingredientId) {
    if (state == null) return;

    if (isPlus) {
      final updatedItems =
      state!.items.map((item) {
        if (item.ingredientId == ingredientId && item.quantity < 99) {
          return item.copyWith(
            quantity: item.quantity + 1,
            totalPrice: item.price * (item.quantity + 1),
          );
        }
        return item;
      }).toList();
      quantity++;
      state = state!.copyWith(items: updatedItems);
    } else {
      final updatedItems =
      state!.items.map((item) {
        if (item.ingredientId == ingredientId && item.quantity > 1) {
          return item.copyWith(
            quantity: item.quantity - 1,
            totalPrice: item.price * (item.quantity - 1),
          );
        }
        return item;
      }).toList();
      quantity--;
      state = state!.copyWith(items: updatedItems);
    }

    // debounce 걸기
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 600), () async {
      try {
        await repo.patchCartItem(
          cartItemId: cartItemId,
          quantity: quantity,
        );
        print('PATCH 완료: $cartItemId → $quantity');
      } catch (e) {
        print(e);
        rethrow;
      }
    });
  }

  Future<Response> deleteCart(int cartItemId) async {
    if (state == null) throw Exception('장바구니가 비어 있음.');

    final resp = await repo.deleteCart(cartItemId);

    final updatedItems =
        state!.items.where((item) => item.cartItemId != cartItemId).toList();

    state = state!.copyWith(items: updatedItems);
    return resp;
  }
}
