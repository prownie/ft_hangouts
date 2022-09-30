import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/contact.dart';
import 'dart:async';

class databaseController {
  static const _databaseName = 'db_hangouts';

  databaseController._privateConstructor();
  static final databaseController instance =
      databaseController._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: 1,
    );
    CreationsForTest();
    return database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Contact(
              id INTEGER PRIMARY KEY,
              firstName TEXT,
              lastName TEXT,
              phoneNumber TEXT
        )''');
    await db.execute('''CREATE TABLE Message(
            id INTEGER PRIMARY KEY,
            message TEXT NOT NULL,
            contactId INTEGER NOT NULL,
            mine INTEGER NOT NULL,
            datetime INTEGER NOT NULL
          )''');
  }

  Future<int> insertContact(Map<String, dynamic> row) async {
    Database db = await instance.database as Database;
    return await db.insert('Contact', row);
  }

  Future<int> insertMessage(Map<String, dynamic> row) async {
    Database db = await instance.database as Database;
    return await db.insert('Message', row);
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    Database db = await instance.database as Database;
    return await db.query('Contact');
  }

  CreationsForTest() {
    insertContact(new Contact(
            firstName: 'Robin', lastName: 'Pichon', phoneNumber: '0123456789')
        .toMap());
    insertContact(new Contact(
            firstName: 'Prownie', lastName: 'Teuteu', phoneNumber: '9876543210')
        .toMap());
  }
}
