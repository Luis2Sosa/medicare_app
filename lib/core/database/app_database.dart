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
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE treatments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosis TEXT NOT NULL,
        frecuencia TEXT NOT NULL,
        hora TEXT NOT NULL,
        proximaHora TEXT NOT NULL DEFAULT '',
        cantidad INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicamento TEXT NOT NULL,
        dosis TEXT NOT NULL,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        tomado INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicamento TEXT NOT NULL,
          dosis TEXT NOT NULL,
          fecha TEXT NOT NULL,
          hora TEXT NOT NULL,
          tomado INTEGER NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE treatments ADD COLUMN cantidad INTEGER NOT NULL DEFAULT 0
      ''');
    }

    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE treatments ADD COLUMN proximaHora TEXT NOT NULL DEFAULT ''
      ''');

      await db.execute('''
        UPDATE treatments
        SET proximaHora = hora
        WHERE proximaHora = ''
      ''');
    }
  }

  Future<int> insertTreatment(Map<String, dynamic> treatment) async {
    final db = await instance.database;

    final treatmentWithNextHour = {
      ...treatment,
      'proximaHora': treatment['proximaHora'] ?? treatment['hora'],
    };

    return await db.insert(
      'treatments',
      treatmentWithNextHour,
    );
  }

  Future<List<Map<String, dynamic>>> getTreatments() async {
    final db = await instance.database;

    return await db.query(
      'treatments',
      orderBy: 'proximaHora ASC',
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

    final updatedTreatment = {
      ...treatment,
      'proximaHora': treatment['proximaHora'] ?? treatment['hora'],
    };

    return await db.update(
      'treatments',
      updatedTreatment,
      where: 'id = ?',
      whereArgs: [treatment['id']],
    );
  }

  Future<int> insertHistory(Map<String, dynamic> historyItem) async {
    final db = await instance.database;

    return await db.insert(
      'history',
      historyItem,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await instance.database;

    return await db.query(
      'history',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteAllHistory() async {
    final db = await instance.database;

    return await db.delete('history');
  }
}