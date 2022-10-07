import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/models.dart';
import 'dart:async';

class databaseController {
  static const _databaseName = 'db_hangouts';

  static final databaseController instance = new databaseController.internal();

  factory databaseController() => instance;
  static Database? _db;

  static Database? _database;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDatabase();
    return _db;
  }

  databaseController.internal();

  _initDatabase() async {
    print('in init');
    final database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: _onCreate,
      version: 1,
    );
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

  Future<int> insertContact(Contact contact) async {
    Database db = await instance.db as Database;
    Map<String, dynamic> row = {
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
    };
    return await db.insert('Contact', row);
  }

  Future<int> insertMessage(Map<String, dynamic> row) async {
    Database db = await instance.db as Database;
    return await db.insert('Message', row);
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    Database db = await instance.db as Database;
    return await db.query('Contact');
  }

  Future<dynamic> updateContact(Contact contact) async {
    Map<String, dynamic> row = {
      'id': contact.id,
      'firstName': contact.firstName,
      'lastName': contact.lastName,
      'phoneNumber': contact.phoneNumber,
    };
    Database db = await instance.db as Database;
    db.update('Contact', row, where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<dynamic> deleteContact(Contact contact) async {
    Database db = await instance.db as Database;
    db.delete('Contact', where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<dynamic> getContactFromId(String id) async {
    List<String> ids = [id];
    Database db = await instance.db as Database;
    return await db.query('Contact',
        columns: ['id', 'firstName', 'lastName', 'phoneNumber'],
        where: 'id = ?',
        whereArgs: ids,
        limit: 1);
  }

  CreationsForTest() {
    insertContact(new Contact(
        firstName: 'Robin', lastName: 'Pichon', phoneNumber: '0123456789'));
    insertContact(new Contact(
        firstName: 'Prownie', lastName: 'Teuteu', phoneNumber: '9876543210'));
    insertContact(new Contact(
        firstName: 'Thomas', lastName: 'Grangeot', phoneNumber: '9876543210'));
    insertContact(new Contact(
        firstName: 'jdel', lastName: 'ros', phoneNumber: '9876543210'));
    insertContact(new Contact(
        firstName: 'edep', lastName: 'auw', phoneNumber: '9876543210'));
    insertContact(new Contact(
        firstName: 'fr', lastName: 'frey', phoneNumber: '9876543210'));
    print('created contacts');
  }
}
