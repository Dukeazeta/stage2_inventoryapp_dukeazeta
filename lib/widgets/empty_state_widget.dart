import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool hasProducts;
  final VoidCallback onAddProduct;

  const EmptyStateWidget({
    super.key,
    required this.hasProducts,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasProducts ? Icons.search_off : Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasProducts ? 'No products found' : 'No products yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasProducts
                ? 'Try adjusting your search terms'
                : 'Add your first product to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          if (!hasProducts) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add First Product'),
            ),
          ],
        ],
      ),
    );
  }
}