// Product model for storing inventory items
class Product {
  final String id; // Unique identifier
  String name; // Product name
  int quantity; // How many we have
  double price; // Price per item
  String? imagePath; // Optional picture
  DateTime createdAt; // When product was added

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory for new products (auto-generates ID)
  factory Product.create({
    required String name,
    required int quantity,
    required double price,
    String? imagePath,
  }) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quantity: quantity,
      price: price,
      imagePath: imagePath,
    );
  }

  // Create a copy with some fields changed
  Product copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? imagePath,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
    );
  }

  // Get price with Naira symbol and 2 decimals
  String get formattedPrice {
    return '₦${price.toStringAsFixed(2)}';
  }

  // Get quantity as string
  String get formattedQuantity {
    return quantity.toString();
  }

  // Check if product data is valid
  bool get isValid {
    return name.trim().isNotEmpty &&
           quantity >= 0 &&
           price >= 0;
  }

  // Convert to Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image_path': imagePath,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create product from Map (from SQLite)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      imagePath: map['image_path'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  // Convert to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
    };
  }

  // Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      imagePath: json['imagePath'] as String?,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, quantity: $quantity, price: $price, imagePath: $imagePath)';
  }

  // Two products are same if they have same ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// How to sort products
enum SortCriteria {
  nameAsc,    // A to Z
  nameDesc,   // Z to A
  priceAsc,    // Low to high
  priceDesc,   // High to low
  quantityAsc, // Low to high
  quantityDesc, // High to low
}