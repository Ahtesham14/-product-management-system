import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/category_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: FutureBuilder(
        future: categoryProvider.fetchCategories(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (categoryProvider.categories.isEmpty) {
            return const Center(child: Text("No categories available."));
          }
          return ListView.builder(
            itemCount: categoryProvider.categories.length,
            itemBuilder: (ctx, i) {
              final category = categoryProvider.categories[i];
              return ListTile(
                title: Text(category["name"]),
                onTap: () {
                  // Navigate to subcategories or products
                },
              );
            },
          );
        },
      ),
    );
  }
}
