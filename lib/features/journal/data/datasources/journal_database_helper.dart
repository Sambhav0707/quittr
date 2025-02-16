import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry_model.dart';

class JournalDatabaseHelper {
  static final JournalDatabaseHelper instance = JournalDatabaseHelper._init();
  static Database? _database;

  JournalDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('journal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<JournalEntry> create(JournalEntry entry) async {
    final db = await database;
    final id = await db.insert('journal_entries', entry.toMap());
    return entry.copyWith(id: id);
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'journal_entries',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => JournalEntry.fromMap(maps[i]));
  }
} 