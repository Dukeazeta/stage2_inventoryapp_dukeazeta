import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';
import '../widgets/simple_image_picker.dart';
import '../widgets/product_form_widget.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeEditMode();
    }
  }

  void _initializeEditMode() {
    final product = widget.product!;
    _nameController.text = product.name;
    _quantityController.text = product.quantity.toString();
    _priceController.text = product.price.toString();
    _imagePath = product.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final quantity = int.parse(_quantityController.text);
      final price = double.parse(_priceController.text);

      if (widget.product == null) {
        final newProduct = Product.create(
          name: name,
          quantity: quantity,
          price: price,
          imagePath: _imagePath,
        );
        await DatabaseService.addProduct(newProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final updatedProduct = widget.product!.copyWith(
          name: name,
          quantity: quantity,
          price: price,
          imagePath: _imagePath,
        );
        await DatabaseService.updateProduct(updatedProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setImage(String? imagePath) {
    setState(() {
      _imagePath = imagePath;
    });
  }

  void _resetForm() {
    _nameController.clear();
    _quantityController.clear();
    _priceController.clear();
    setState(() {
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            SimpleImagePicker(
              initialImagePath: _imagePath,
              onImageSelected: _setImage,
            ),

            const SizedBox(height: 24),

            // Product Form
            ProductFormWidget(
              formKey: _formKey,
              nameController: _nameController,
              quantityController: _quantityController,
              priceController: _priceController,
              onSave: _saveProduct,
              onReset: _resetForm,
              isLoading: _isLoading,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}