import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final product = cartItems[i];
                      return ListTile(
                        leading: SizedBox(
                          width: 50, // Specify the width of the image
                          child: Image.file(
                            File(product.images.first),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          "Price: \$${product.offerPrice} x ${product.quantity} = \$${(product.offerPrice * product.quantity).toStringAsFixed(2)}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: product.quantity > 1
                                  ? () {
                                      cartProvider.updateQuantity(
                                          product.id!, product.quantity - 1);
                                    }
                                  : null,
                            ),
                            Text(product.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: product.quantity < product.quantity
                                  ? () {
                                      cartProvider.updateQuantity(
                                          product.id!, product.quantity + 1);
                                    }
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                cartProvider.removeFromCart(product.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${cartProvider.totalCartValue.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
