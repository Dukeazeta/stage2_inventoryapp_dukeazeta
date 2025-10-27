import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/database_service.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/detail_info_card.dart';
import 'add_edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _refreshProduct();
  }

  Future<void> _refreshProduct() async {
    final updatedProduct = await DatabaseService.getProductById(_product.id);
    if (updatedProduct != null) {
      setState(() {
        _product = updatedProduct;
      });
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${_product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await DatabaseService.deleteProduct(_product.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting product: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: _product),
      ),
    );

    if (result == true) {
      await _refreshProduct();
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildLowStockBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.zero,
      ),
      child: const Text(
        'Low Stock',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: _navigateToEdit,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Product',
          ),
          IconButton(
            onPressed: _deleteProduct,
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ProductImageWidget(imagePath: _product.imagePath),

            const SizedBox(height: 32),

            // Product Name
            DetailInfoCard(
              title: 'Product Name',
              content: _product.name,
              icon: Icons.label,
              onTap: () => _copyToClipboard(_product.name),
            ),

            const SizedBox(height: 16),

            // Quantity
            DetailInfoCard(
              title: 'Quantity',
              content: _product.formattedQuantity,
              icon: Icons.inventory_2,
              onTap: () => _copyToClipboard(_product.formattedQuantity),
              trailing: _product.quantity <= 5 ? _buildLowStockBadge() : null,
            ),

            const SizedBox(height: 16),

            // Price
            DetailInfoCard(
              title: 'Price per Unit',
              content: _product.formattedPrice,
              customIcon: '₦',
              onTap: () => _copyToClipboard(_product.formattedPrice),
            ),

            const SizedBox(height: 16),

            // Total Value
            DetailInfoCard(
              title: 'Total Value',
              content: '${(_product.price * _product.quantity).toStringAsFixed(2)}',
              customIcon: '₦',
              onTap: () => _copyToClipboard(
                '${(_product.price * _product.quantity).toStringAsFixed(2)}',
              ),
            ),

            const SizedBox(height: 16),

            // Product ID
            DetailInfoCard(
              title: 'Product ID',
              content: _product.id,
              icon: Icons.fingerprint,
              onTap: () => _copyToClipboard(_product.id),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _navigateToEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: _deleteProduct,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}