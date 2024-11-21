import 'package:flutter/material.dart';
import 'package:smart_cart/classes/product.dart';
import 'package:smart_cart/services/productServices.dart';
import 'package:smart_cart/widgets/productCard.dart';

class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Product>?>(
        future: _productService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if no data was found
            return Center(child: Text('No products available.'));
          } else {
            // Data fetched successfully, display products in GridView
            List<Product> products = snapshot.data!;

            return GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: products.map((product) {
                print(product.title);
                return ProductCard(product: product);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
