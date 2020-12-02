import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'movies.db';
  static final _dbVersion = 1;

  static final _tableName = 'favourite_movies';
  static final id = '_id';
  static final movieId = 'movieId';
  static final movieName = 'name';
  static final overview = 'overview';

  static final DatabaseHelper instance = DatabaseHelper._createInstance();
  DatabaseHelper._createInstance();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();

    return _database;
  }

  _createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute(
        'CREATE TABLE $_tableName ($id INTEGER PRIMARY KEY, $movieId INTEGER NOT NULL, $movieName TEXT NOT NULL, $overview TEXT NOT NULL)');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<bool> isFavourite(int id) async {
    Database db = await instance.database;
    var query =
        await db.query(_tableName, where: '$movieId = ?', whereArgs: [id]);
    try {
      if (query[0]['movieId'] == id) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future removeFavourite(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$movieId = ?', whereArgs: [id]);
  }
}
