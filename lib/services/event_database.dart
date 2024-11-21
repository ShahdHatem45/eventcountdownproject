import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:new_new_project/models/event_model.dart';

class EventDatabase {
  static final EventDatabase instance = EventDatabase._init();
  static Database? _database;

  EventDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE events (
      id $idType,
      title $textType,
      description $textType,
      date $dateType,
      imagePath $textType
    )
    ''');
  }

  Future<Event> createEvent(Event event) async {
    final db = await instance.database;
    final id = await db.insert('events', event.toMap());
    return event.copyWith(id: id);
  }

  Future<List<Event>> getAllEvents() async {
    final db = await instance.database;
    final result = await db.query('events');

    return result.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await instance.database;
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
