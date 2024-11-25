import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  int get cartCount => _cartItems.length;

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    if (cartData != null) {
      final List<dynamic> decodedData = json.decode(cartData);
      _cartItems = decodedData
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  // Save cart items to SharedPreferences
  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_cartItems.map((e) => e.toMap()).toList());
    await prefs.setString('cartItems', cartData);
  }

  double get totalCartValue {
    double total = 0;
    for (var item in _cartItems) {
      total += item.offerPrice * item.quantity;
    }
    return total;
  }

  // Add product to cart
  void addToCart(Product product) {
    // Check if the product is already in the cart
    final existingProductIndex =
        _cartItems.indexWhere((prod) => prod.id == product.id);

    if (existingProductIndex != -1) {
      // Increase quantity if product exists
      _cartItems[existingProductIndex].quantity++;
    } else {
      // Add new product if it doesn't exist in the cart
      _cartItems.add(product);
    }
    notifyListeners();
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }

  // Update product quantity
  void updateQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((prod) => prod.id == productId);
    if (index != -1) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }
}
