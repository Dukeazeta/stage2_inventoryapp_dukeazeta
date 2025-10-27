import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductsListWidget extends StatelessWidget {
  final List<Product> products;
  final Future<void> Function() onRefresh;
  final Function(Product) onTap;
  final Function(Product) onEdit;
  final Function(Product) onDelete;

  const ProductsListWidget({
    super.key,
    required this.products,
    required this.onRefresh,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => onTap(product),
            onEdit: () => onEdit(product),
            onDelete: () => onDelete(product),
          );
        },
      ),
    );
  }
}