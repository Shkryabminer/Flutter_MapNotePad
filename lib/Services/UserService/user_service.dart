
import 'dart:io';

import 'package:map_note_pad/Models/User/user.dart';
import 'package:map_note_pad/Services/UserService/user_serice_interface.dart';
import 'package:map_note_pad/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserService implements IUserService
{
  UserService._();

   static final UserService userService = UserService._();

   static Database? _database;

  Future<Database?> get database async{
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    var dbpath = await getDatabasesPath();
    String path = dbpath+Constants.databaseName;

    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${Constants.userTable} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "authorizationType INTEGER,"
          "name TEXT,"
          "email TEXT,"
          "password TEXT"
          ")");

      await db.execute("CREATE TABLE ${Constants.pinsTable} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "userEmail TEXT,"
          "longitude REAL,"
          "latitude REAL,"
          "label TEXT,"
          "isFavorite INTEGER,"
          "description TEXT"
          ")");

      await db.execute("CREATE TABLE ${Constants.eventsTable} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "userEmail TEXT,"
          "pinId INTEGER,"
          "label TEXT,"
          "date TEXT,"
          "time TEXT"
          ")");
    });
  }
    @override
  Future<int> addOrUpdateUser(User user) async {
    int res = 0;
    final existingUser = await getUserById(user.id);
    if(existingUser != null)
      {
      res = await _updateUser(existingUser);
      }
    else {
      res = await _insertUser(user);
    }

    return res;
  }

  @override
  Future<User?> getUserById(int id) async {
    final db = await database;
    var res = await  db!.query(Constants.userTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : null ;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db!.query(Constants.userTable);
    List<User> list =
    res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> _updateUser(User existingUser) async {
    final db = await database;
    var res = await db!.update(Constants.userTable, existingUser.toMap(),
        where: "id = ?", whereArgs: [existingUser.id]);
    return res;
  }

  Future<int> _insertUser(User newUser) async {
    final db = await database;
    var res = await db!.insert(Constants.userTable, newUser.toMap());
    return res;
  }


}