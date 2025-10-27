import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'products';
  static const String _columnId = 'id';
  static const String _columnName = 'name';
  static const String _columnQuantity = 'quantity';
  static const String _columnPrice = 'price';
  static const String _columnImagePath = 'image_path';
  static const String _columnCreatedAt = 'created_at';

  // Initialize the database
  static Future<void> init() async {
    if (_database != null) return;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'storekeeper.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create database table
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId TEXT PRIMARY KEY,
        $_columnName TEXT NOT NULL,
        $_columnQuantity INTEGER NOT NULL,
        $_columnPrice REAL NOT NULL,
        $_columnImagePath TEXT,
        $_columnCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    await init();
    return _database!;
  }

  // Add a new product
  static Future<void> addProduct(Product product) async {
    final db = await database;
    await db.insert(
      _tableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing product
  static Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      _tableName,
      product.toMap(),
      where: '$_columnId = ?',
      whereArgs: [product.id],
    );
  }

  // Delete a product
  static Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete all products
  static Future<void> deleteAllProducts() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // Get all products
  static Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: '$_columnCreatedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get product by ID
  static Future<Product?> getProductById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Search products by name
  static Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnName LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '$_columnCreatedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get products count
  static Future<int> getProductsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get total inventory value
  static Future<double> getTotalInventoryValue() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM($_columnQuantity * $_columnPrice) as total FROM $_tableName'
    );
    final total = result.first['total'] as double?;
    return total ?? 0.0;
  }

  // Get low stock products (quantity <= 5)
  static Future<List<Product>> getLowStockProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnQuantity <= ?',
      whereArgs: [5],
      orderBy: '$_columnQuantity ASC',
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Close the database
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Check if database is initialized
  static bool get isInitialized => _database != null;
}