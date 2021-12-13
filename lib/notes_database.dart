import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_sql/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFields.id},
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}