import 'package:flutter/material.dart';
import '../models/product.dart';

class SortMenuWidget extends StatelessWidget {
  final Function(SortCriteria) onSortSelected;

  const SortMenuWidget({
    super.key,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<SortCriteria>(
        onSelected: onSortSelected,
        child: const Icon(Icons.swap_vert, size: 20),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortCriteria.nameAsc,
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text('Name (A-Z)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortCriteria.nameDesc,
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text('Name (Z-A)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortCriteria.priceAsc,
          child: Row(
            children: [
              SizedBox(
                width: 18,
                child: Text(
                  '₦',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('Price (Low to High)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortCriteria.priceDesc,
          child: Row(
            children: [
              SizedBox(
                width: 18,
                child: Text(
                  '₦',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('Price (High to Low)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortCriteria.quantityAsc,
          child: Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text('Quantity (Low to High)'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: SortCriteria.quantityDesc,
          child: Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text('Quantity (High to Low)'),
            ],
          ),
        ),
      ],
      ),
    );
  }
}