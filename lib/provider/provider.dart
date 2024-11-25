import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/model.dart';
import 'package:shopping_app/utils/data_base.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsData = prefs.getString('products');
    if (productsData != null) {
      final List<dynamic> decodedData = json.decode(productsData);
      _products = decodedData
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsData = json.encode(_products.map((e) => e.toMap()).toList());
    await prefs.setString('products', productsData);
  }

  Future<void> fetchProducts() async {
    _products = await DatabaseHelper.instance.fetchProducts();
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners(); // Notifies the UI to refresh
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((prod) => prod.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }

  // Future<void> addProduct(Product product) async {
  //   await DatabaseHelper.instance.insertProduct(product);
  //   await fetchProducts();
  // }

  // Future<void> updateProduct(Product product) async {
  //   await DatabaseHelper.instance.updateProduct(product);
  //   await fetchProducts();
  // }

  // Future<void> deleteProduct(int id) async {
  //   await DatabaseHelper.instance.deleteProduct(id);
  //   await fetchProducts();
  // }
}
