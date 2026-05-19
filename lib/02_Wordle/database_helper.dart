import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../app_state.dart'; // Damit wir die User-Klasse kennen

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wordle.db');
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

  // Hier erstellen wir die Tabelle
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        score INTEGER NOT NULL,
        iconCode INTEGER NOT NULL
      )
    ''');
  }

  // Daten speichern
  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', {
      'name': user.name,
      'score': user.scoreWordle,
      'iconCode': user.icon.codePoint, // Wir speichern nur die Zahl des Icons
    });
  }

  Future<int> deleteUserDB(User user)async{
    final db = await instance.database;
    return await db.delete('users',
    where: 'name = ?',
    whereArgs: [user.name]
    
    );
  }

  //score speicher/aktualiseren
  Future<int> addScoreDB(User activeUser)async{
    final db = await instance.database;
    return await db.update(
      'users',                        // name der Tabell  
      {'score': activeUser.scoreWordle,},   // was soll geändert werden
      where: 'name = ?',              // sicherheitsplatzhalter
      whereArgs: [activeUser.name],   // bei wem soll es geändert weden
      );
  }
  

  // Alle User laden
  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');

    return result.map((json) => User(
      json['name'] as String,
      json['score'] as int,
      icon: IconData(
        json['iconCode'] as int, 
        fontFamily: 'MaterialIcons',
      ),
    )).toList();
  }
}