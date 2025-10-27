import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final VoidCallback onSave;
  final VoidCallback onReset;
  final bool isLoading;
  final bool isEditing;

  const ProductFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.quantityController,
    required this.priceController,
    required this.onSave,
    required this.onReset,
    required this.isLoading,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Name
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              hintText: 'Enter product name',
              prefixIcon: Icon(Icons.label_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Quantity with label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              // Quantity input with plus/minus buttons
              Row(
                children: [
                  // Minus button
                  Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        final currentValue = int.tryParse(quantityController.text) ?? 0;
                        if (currentValue > 0) {
                          quantityController.text = (currentValue - 1).toString();
                        }
                      },
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // Quantity input field
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextFormField(
                        controller: quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          final quantity = int.tryParse(value);
                          if (quantity == null || quantity < 0) {
                            return 'Please enter a valid quantity';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Plus button
                  Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        final currentValue = int.tryParse(quantityController.text) ?? 0;
                        quantityController.text = (currentValue + 1).toString();
                      },
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Price
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              hintText: 'Enter price',
              prefixIcon: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: const Text(
                  '₦',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d+\.?\d{0,2}'),
              ),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSave(),
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onSave,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(isEditing ? Icons.save_outlined : Icons.add_outlined),
              label: Text(
                isLoading
                    ? 'Saving...'
                    : isEditing
                        ? 'Update Product'
                        : 'Add Product',
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cancel Button
          SizedBox(
            width: 200,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_outlined),
              label: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}