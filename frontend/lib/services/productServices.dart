import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_cart/classes/product.dart';
import 'package:smart_cart/consts.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Product>?> getAllProducts() async {
    final _url = Uri.parse('$url/products');

    try {
      final response = await http.get(
        _url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as a List of Products
        final List<dynamic> jsonList = json.decode(response.body);

        List<Product> products =
            jsonList.map((json) => Product.fromMap(json)).toList();

        return products;
      } else {
        // Show error if status code is not 200
        Fluttertoast.showToast(
            msg: 'Failed to load products: ${response.body}');
        print(response.body);
        return null;
      }
    } catch (e) {
      // Handle any other error and show toast
      Fluttertoast.showToast(msg: 'Error: $e');
      return null;
    }
  }

  Future<void> addToCart(String userId, String productId) async {
    final _url = Uri.parse('$url/api/cart/add-online');
    final Map<String, String> body = {
      'userId': userId,
      'productId': productId,
    };
    try {
      final response = await http.post(
        _url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as a List of Products
        Fluttertoast.showToast(
          msg: 'Item added to cart',
          backgroundColor: Colors.grey,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to add product to your cart',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        print(response.body);
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to add product to your cart $e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
