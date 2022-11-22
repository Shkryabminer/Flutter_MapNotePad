import 'dart:async';
import 'dart:io';

import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants.dart';

class PinServiceImpl implements PinService
{
  SettingsService _settingsService = SettingsServiceImpl();

  PinServiceImpl._();
  static final PinServiceImpl pinService = PinServiceImpl._();

  static Database? _database;

  Future<Database?> get database async{
    if (_database != null) {
      return _database;
    }

    _database = await initTable();
    return _database;
  }

  initTable() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //String path = documentsDirectory.path + Constants.databaseName;
    var dbpath = await getDatabasesPath();
    String path = dbpath+Constants.databaseName;
    return await openDatabase(
        path, version: 1, onOpen: _onOpen, onCreate: _onCreate);
  }
  FutureOr<void> _onCreate(Database db, int version) async
  {
    await db.execute("CREATE TABLE IF NOT EXISTS ${Constants.pinsTable} ("
        "id INTEGER PRIMARY KEY,"
        "userEmail TEXT,"
        "longitude REAL,"
        "latitude REAL,"
        "label TEXT,"
        "isFavorite INTEGER,"
        "description TEXT"
        ")");
  }

  FutureOr<void> _onOpen(Database db) async
  {
    await db.execute("CREATE TABLE IF NOT EXISTS ${Constants.pinsTable} ("
        "id INTEGER PRIMARY KEY,"
        "userEmail TEXT,"
        "longitude REAL,"
        "latitude REAL,"
        "label TEXT,"
        "isFavorite INTEGER,"
        "description TEXT"
        ")");
  }

  @override
  Future<int> addOrUpdatePin(Pin pin) async {
    int res = 0;
    if(pin.id !=null) {
      //final existingPin = await getPinById(pin.id!);

      //if (existingPin != null) {
        res = await _updatePin(pin);
      }
      else {
        res = await _insertPin(pin);
      }


    return res;
  }

  @override
  Future<List<Pin?>> getPinsByUserEmail(String email) async {
    final allPins = await  getAllPins();
    final res = allPins.where((element) => element.userEmail == email).toList();
    return res;
  }

  @override
  Future<Pin?> getPinById(int id) async {
    final db = await database;
    var res = await  db!.query(Constants.pinsTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Pin.fromMap(res.first) : null ;
  }
  @override
  Future<List<Pin>> getAllPins() async {
    final db = await database;
    var res = await db!.query(Constants.pinsTable);
    List<Pin> list =
    res.isNotEmpty ? res.map((c) => Pin.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> _updatePin(Pin existingPin) async {
    final db = await database;
    var res = await db!.update(Constants.pinsTable, existingPin.toMap(),
        where: "id = ?", whereArgs: [existingPin.id]);
    return res;
  }

  Future<int> _insertPin(Pin newPin) async {
    final db = await database;
    var res = await db!.insert(Constants.pinsTable, newPin.toMap());
    return res;
  }

  @override
  Future<int> deletePin(Pin pin) async {
    // TODO: implement deletePin
    final db = await database;
    var res = await db!.delete('${Constants.pinsTable}', where: 'id=?', whereArgs: [pin.id]);
    return res;
  }
}