import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/sort_menu_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/products_list_widget.dart';
import 'add_edit_product_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  SortCriteria _currentSortCriteria = SortCriteria.nameAsc;

  @override
  void initState() {
    super.initState();

    // Add error handling to prevent uncaught exceptions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });

    _searchController.addListener(() {
      _filterProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final products = await DatabaseService.getAllProducts();

      // Sort products locally based on criteria
      List<Product> sortedProducts;
      switch (_currentSortCriteria) {
        case SortCriteria.nameAsc:
          sortedProducts = List.from(products)..sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortCriteria.nameDesc:
          sortedProducts = List.from(products)..sort((a, b) => b.name.compareTo(a.name));
          break;
        case SortCriteria.priceAsc:
          sortedProducts = List.from(products)..sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortCriteria.priceDesc:
          sortedProducts = List.from(products)..sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortCriteria.quantityAsc:
          sortedProducts = List.from(products)..sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        case SortCriteria.quantityDesc:
          sortedProducts = List.from(products)..sort((a, b) => b.quantity.compareTo(a.quantity));
          break;
      }

      if (mounted) {
        setState(() {
          _products = sortedProducts;
          _filteredProducts = sortedProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _filterProducts() async {
    final query = _searchController.text.trim();
    final searchedProducts = await DatabaseService.searchProducts(query);
    // Sort searched products locally based on criteria
      List<Product> sortedProducts;
      switch (_currentSortCriteria) {
        case SortCriteria.nameAsc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortCriteria.nameDesc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => b.name.compareTo(a.name));
          break;
        case SortCriteria.priceAsc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortCriteria.priceDesc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortCriteria.quantityAsc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        case SortCriteria.quantityDesc:
          sortedProducts = List.from(searchedProducts)..sort((a, b) => b.quantity.compareTo(a.quantity));
          break;
      }

    setState(() {
      _filteredProducts = sortedProducts;
    });
  }

  void _sortProducts(SortCriteria criteria) {
    setState(() {
      _currentSortCriteria = criteria;
      // Sort filtered products locally based on criteria
      switch (criteria) {
        case SortCriteria.nameAsc:
          _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortCriteria.nameDesc:
          _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
          break;
        case SortCriteria.priceAsc:
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortCriteria.priceDesc:
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortCriteria.quantityAsc:
          _filteredProducts.sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        case SortCriteria.quantityDesc:
          _filteredProducts.sort((a, b) => b.quantity.compareTo(a.quantity));
          break;
      }
    });
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await DatabaseService.deleteProduct(product.id);
      await _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
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

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(product);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditProductScreen(),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  void _navigateToProductDetail(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoreKeeper'),
        actions: [
          SortMenuWidget(onSortSelected: _sortProducts),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: _filterProducts,
          ),

          // Products List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? EmptyStateWidget(
                        hasProducts: _products.isNotEmpty,
                        onAddProduct: _navigateToAddProduct,
                      )
                    : ProductsListWidget(
                        products: _filteredProducts,
                        onRefresh: _loadProducts,
                        onTap: _navigateToProductDetail,
                        onEdit: _navigateToEditProduct,
                        onDelete: _showDeleteConfirmation,
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}