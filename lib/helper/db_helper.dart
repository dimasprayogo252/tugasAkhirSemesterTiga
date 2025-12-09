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
        imagePath TEXT,
        latitude DOUBLE NOT NULL,
        longitude DOUBLE NOT  NULL,
        status TEXT NOT NULL,
        date TEXT NOT NULL,
        officerNote TEXT,
        completionPhotoPath TEXT
      )
    ''');
  }

  Future<List<ReportModel>> getAllReports() async {
    final db = await instance.database;
    final result = await db.query('reports', orderBy: 'id DESC');
    return result.map((json) => ReportModel.fromMap(json)).toList();
  }

  Future<int> insertReport(ReportModel report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }
  Future<List<ReportModel>> getReports() async {
    final db = await instance.database;
    final result = await db.query('reports', orderBy: 'id DESC');
    return result.map((json) => ReportModel.fromMap(json)).toList();
  }
  Future<int> updateReport(ReportModel report) async {
    final db = await instance.database;
    return await db.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }
  Future<int> deleteReport(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
