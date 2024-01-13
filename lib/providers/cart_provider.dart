import 'package:buyers/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Other methods...

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  // Add or update item in the cart
  void addOrUpdateItem(CartItem newItem) {
    int index = _cartItems.indexWhere((item) => item.productId == newItem.productId);

    if (index != -1) {
      // Product is already in the cart, update the quantity
      _cartItems[index] = CartItem(
        productId: newItem.productId,
        productName: newItem.productName,
        price: newItem.price,
        quantity: _cartItems[index].quantity + newItem.quantity,
      );
    } else {
      // Product is not in the cart, add it
      _cartItems.add(newItem);
    }

    // Notify listeners about the change
    notifyListeners();
  }
}
