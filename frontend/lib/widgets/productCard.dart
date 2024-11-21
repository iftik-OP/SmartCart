import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cart/classes/product.dart';
import 'package:smart_cart/consts.dart';
import 'package:smart_cart/providers/userProvider.dart';
import 'package:smart_cart/services/productServices.dart';

class ProductCard extends StatefulWidget {
  Product product;
  ProductCard({required this.product, super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.2)),
                child: Text(
                  widget.product.category,
                  style: TextStyle(color: Colors.black, fontSize: 8),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Rs. ${widget.product.price.toString()}', // Example price
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle add to cart action
              ProductService().addToCart('', widget.product.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryYellow,
              minimumSize: Size(double.infinity, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
