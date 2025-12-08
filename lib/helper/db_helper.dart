import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/report_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ecopatrol.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertReport(ReportModel report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
