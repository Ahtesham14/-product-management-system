import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/provider/provider.dart';
import 'package:shopping_app/screen/add_product_screen.dart';
import 'package:shopping_app/screen/cart_screen.dart';
import 'package:shopping_app/screen/product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, cartProvider, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => CartScreen()),
                    );
                  },
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddEditProductScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text("No products available"))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) {
                final product = products[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: product.images.isNotEmpty
                        ? Image.file(
                            File(product.images.first),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(product.name),
                    subtitle: Text(
                      "Price: \$${product.price}, Offer: \$${product.offerPrice}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                AddEditProductScreen(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
