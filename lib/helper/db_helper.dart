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

    return await openDatabase(
      path,
      version: 2, // UPGRADE versi database
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // -------------------------------------------------------------------------
  //  CREATE TABLE — struktur terbaru (SESUAI model)
  // -------------------------------------------------------------------------
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imagePath TEXT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        status TEXT NOT NULL,
        date TEXT NOT NULL,
        officerNote TEXT,
        completionPhotoPath TEXT,
        isCompleted INTEGER DEFAULT 0
      )
    ''');
  }

  // -------------------------------------------------------------------------
  //  UPGRADE DATABASE — agar perubahan struktur tidak perlu hapus DB
  // -------------------------------------------------------------------------
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE reports ADD COLUMN isCompleted INTEGER DEFAULT 0");
    }
  }

  // -------------------------------------------------------------------------
  //  GET ALL REPORTS
  // -------------------------------------------------------------------------
  Future<List<ReportModel>> getAllReports() async {
    final db = await instance.database;
    final result = await db.query('reports', orderBy: 'id DESC');
    return result.map((json) => ReportModel.fromMap(json)).toList();
  }

  // -------------------------------------------------------------------------
  //  INSERT
  // -------------------------------------------------------------------------
  Future<int> insertReport(ReportModel report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }

  // -------------------------------------------------------------------------
  //  UPDATE
  // -------------------------------------------------------------------------
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

