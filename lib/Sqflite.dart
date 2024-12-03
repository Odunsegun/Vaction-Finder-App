import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE UserData (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            phone TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertUserData(String email, String? phone) async {
    final db = await database;
    await db.insert(
      'UserData',
      {'email': email, 'phone': phone},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('UserData');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUserData(String email, String? phone) async {
    final db = await database;
    await db.update(
      'UserData',
      {'email': email, 'phone': phone},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
