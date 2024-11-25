class Product {
  final String? id; // Nullable for new products
  final String name;
  final double price;
  final double offerPrice;
  int quantity;
  final String description;
  final List<String> images;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.quantity,
    required this.description,
    required this.images,
  });

  // Convert Product to Map for local storage or APIs
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'offerPrice': offerPrice,
      'quantity': quantity,
      'description': description,
      'images': images,
    };
  }

  // Convert Map to Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      price: map['price'] as double,
      offerPrice: map['offerPrice'] as double,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      images: List<String>.from(map['images'] as List),
    );
  }
}
