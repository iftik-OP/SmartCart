import 'package:flutter/material.dart';
import 'package:smart_cart/classes/product.dart';
import 'package:smart_cart/services/productServices.dart';

class ProductProvider with ChangeNotifier {
  // List to store all fetched products
  List<Product> _allProducts = [];

  // Getter to access products
  List<Product> get allProducts => _allProducts; // Return a copy of the list

  // Method to fetch products (simulate with dummy data or fetch from API)
  Future<void> fetchProducts() async {
    // Notify listeners that the state has changed
    final products = await ProductService().getAllProducts();
    if (products != null) {
      _allProducts = products;
    }
    notifyListeners();
  }

  // Add a new product to the list
  void addProduct(Product product) {
    _allProducts.add(product);
    notifyListeners();
  }

  // Update an existing product
  void updateProduct(String id, Product updatedProduct) {
    final productIndex = _allProducts.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _allProducts[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  // Remove a product from the list
  void removeProduct(String id) {
    _allProducts.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
