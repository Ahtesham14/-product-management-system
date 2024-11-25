import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/model.dart';
import 'package:shopping_app/provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _selectedImages = [];
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _offerPriceController.text = widget.product!.offerPrice.toString();
      _quantityController.text = widget.product!.quantity.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty && widget.product == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }

      // Create Product instance
      final newProduct = Product(
        id: widget.product?.id ?? UniqueKey().toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        offerPrice: double.parse(_offerPriceController.text),
        quantity: int.parse(_quantityController.text),
        description: _descriptionController.text,
        images: _selectedImages.map((image) => image.path).toList(),
      );

      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (widget.product == null) {
        productProvider.addProduct(newProduct);
      } else {
        productProvider.updateProduct(newProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Images', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages
                      .map((image) => Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(image,
                                  width: 80, height: 80, fit: BoxFit.cover),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.remove(image);
                                  });
                                },
                              ),
                            ],
                          ))
                      .toList(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Images'),
                  onPressed: _pickImages,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a product name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Price (Before Discount)'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the price';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid price';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _offerPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Offer Price (After Discount)'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the offer price';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid offer price';
                    if (double.parse(value) >=
                        double.parse(_priceController.text)) {
                      return 'Offer price must be less than price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Available Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the quantity';
                    if (int.tryParse(value) == null)
                      return 'Please enter a valid quantity';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Product Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a product description';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: Text(
                      widget.product == null ? 'Add Product' : 'Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
