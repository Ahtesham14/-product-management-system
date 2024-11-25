import 'package:flutter/material.dart';
import 'package:shopping_app/services/api_services.dart';

class CategoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _subcategories = [];

  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get subcategories => _subcategories;

  Future<void> fetchCategories() async {
    try {
      _categories = await APIService.fetchCategories();
      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching categories: $error");
    }
  }

  Future<void> fetchSubcategories(int categoryId) async {
    try {
      _subcategories = await APIService.fetchSubcategories(categoryId);
      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching subcategories: $error");
    }
  }
}
