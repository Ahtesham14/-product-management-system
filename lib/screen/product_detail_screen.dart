import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/model.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/provider/provider.dart';
import 'package:shopping_app/screen/add_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddEditProductScreen(product: product),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, productProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Slider for Product Images
              if (product.images.isNotEmpty)
                CarouselSlider(
                  items: product.images
                      .map((imagePath) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                )
              else
                const Center(child: Text("No images available")),

              const SizedBox(height: 16),

              // Product Details
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "Price: \$${product.price.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                "Offer Price: \$${product.offerPrice.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                "Available Quantity: ${product.quantity}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                "Description: ${product.description}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),

              // Edit & Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              AddEditProductScreen(product: product),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(context, productProvider);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),

              // Add to Cart Button
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: product.quantity > 0
                    ? () {
                        // Check if product quantity is available in stock
                        if (product.quantity > 0) {
                          cartProvider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Product added to cart")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Out of stock!")),
                          );
                        }
                      }
                    : null,
                child: const Text("Add to Cart"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog before deleting the product
  void _showDeleteConfirmation(
      BuildContext context, ProductProvider productProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // productProvider.deleteProduct(product.id);
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.of(context).pop(); // Return to the previous screen
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
