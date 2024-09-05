// ignore_for_file: depend_on_referenced_packages

import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_cart.db');
    print(
        "Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
      'productID INTEGER, name TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER)',
    );
    await db.execute(
      'CREATE TABLE Favourite('
      'productID INTEGER, name TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER)',
    );
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await _databaseService.database;
    await db.insert(
      'Cart',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> products() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart> product(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Cart', where: 'productID = ?', whereArgs: [id]);
    return Cart.fromMap(maps[0]);
  }

  Future<void> minus(Cart product) async {
    final db = await _databaseService.database;
    if (product.count > 1) product.count--;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> add(Cart product) async {
    final db = await _databaseService.database;
    product.count++;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<void> clear() async {
    final db = await _databaseService.database;
    await db.delete('Cart', where: 'count > 0');
  }

  Future<void> insertProductf(Favourite productModel) async {
    final db = await _databaseService.database;
    await db.insert(
      'Favourite',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Favourite>> productsf() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Favourite');
    return List.generate(
        maps.length, (index) => Favourite.fromMap(maps[index]));
  }

  Future<Favourite> productf(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Favourite', where: 'productID = ?', whereArgs: [id]);
    return Favourite.fromMap(maps[0]);
  }

  Future<void> minusf(Favourite product) async {
    final db = await _databaseService.database;
    if (product.count > 1) product.count--;
    await db.update(
      'Favourite',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> addf(Favourite product) async {
    final db = await _databaseService.database;
    product.count++;
    await db.update(
      'Favourite',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> deleteProductf(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Favourite',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearf() async {
    final db = await _databaseService.database;
    await db.delete('Favourite', where: 'count > 0');
  }

  Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_cart.db');
    await deleteDatabase(path);
    print("Đã xóa cơ sở dữ liệu: $path");
  }

  //hsfjkhjksdhjk
  Future<Favourite?> getFavouriteById(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Favourite', where: 'productID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Favourite.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> updateFavourite(Favourite product) async {
    final db = await _databaseService.database;
    await db.update(
      'Favourite',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }
}
