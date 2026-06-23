import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('medicare.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE treatments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosis TEXT NOT NULL,
        frecuencia TEXT NOT NULL,
        hora TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTreatment(Map<String, dynamic> treatment) async {
    final db = await instance.database;

    return await db.insert(
      'treatments',
      treatment,
    );
  }

  Future<List<Map<String, dynamic>>> getTreatments() async {
    final db = await instance.database;

    return await db.query(
      'treatments',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteTreatment(int id) async {
    final db = await instance.database;

    return await db.delete(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTreatment(Map<String, dynamic> treatment) async {
    final db = await instance.database;

    return await db.update(
      'treatments',
      treatment,
      where: 'id = ?',
      whereArgs: [treatment['id']],
    );
  }
}

