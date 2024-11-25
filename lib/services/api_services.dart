import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String _baseUrl = "https://api.clikgett.com/api";
  static const String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOjE0NzE2ODEsImlhdCI6MTczMTkxMTIwNywiZXhwIjoxNzYzNDQ3MjA3fQ.7g_FkmLJkxpBj8tVhLcDdbai8_Scr3Px8ZHVumwPMzI"; // Replace with your token

  /// Common headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  /// Fetch all categories
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final url = Uri.parse("$_baseUrl/categories/allcategoriesuser");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load categories");
    }
  }

  /// Fetch subcategories for a category
  static Future<List<Map<String, dynamic>>> fetchSubcategories(
      int categoryId) async {
    final url =
        Uri.parse("$_baseUrl/categories/subcategories_by_category/$categoryId");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load subcategories");
    }
  }

  /// Fetch products by category and subcategory
  static Future<List<Map<String, dynamic>>> fetchProducts({
    required int categoryId,
    required int subCategoryId,
    int rowCount = 10,
    int offset = 0,
  }) async {
    final url = Uri.parse(
        "$_baseUrl/products/list?CategoryID=$categoryId&SubCategoryID=$subCategoryId&rowCount=$rowCount&Offset=$offset");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Failed to load products");
    }
  }
}
