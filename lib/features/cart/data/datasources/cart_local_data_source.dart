import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final StorageService storageService;

  CartLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonStr = storageService.getString(AppConstants.cartDataKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final jsonList = items.map((i) => i.toJson()).toList();
    await storageService.setString(AppConstants.cartDataKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearCart() async {
    await storageService.remove(AppConstants.cartDataKey);
  }
}
