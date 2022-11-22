import 'dart:async';
import 'dart:io';

import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Services/EventService/event_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class EventServiceImpl implements EventService
{
  SettingsService _settingsService = SettingsServiceImpl();

  EventServiceImpl._();
  static final EventServiceImpl eventService = EventServiceImpl._();

  static Database? _database;

  Future<Database?> get database async{
    if (_database != null) {
      return _database;
    }

    _database = await initTable();
    return _database;
  }

  initTable() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + Constants.databaseName;
    return await openDatabase(
        path, version: 1, onOpen: _onOpen, onCreate: _onCreate);
  }
  FutureOr<void> _onCreate(Database db, int version) async
  {
    await db.execute("CREATE TABLE IF NOT EXISTS ${Constants.eventsTable} ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "userEmail TEXT,"
        "pinId INTEGER,"
        "label TEXT,"
        "date TEXT,"
        "time TEXT"
        ")");
  }

  FutureOr<void> _onOpen(Database db) async
  {
    await db.execute("CREATE TABLE IF NOT EXISTS ${Constants.eventsTable} ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "userEmail TEXT,"
        "pinId INTEGER,"
        "label TEXT,"
        "date TEXT,"
        "time TEXT"
        ")");
  }

  @override
  Future<int> addOrUpdateEvent(Event event) async {
    int res = 0;
    if(event.id !=null) {
      final existingEvent = await getEventById(event.id!);

      if (existingEvent != null) {
        res = await _updateEvent(event);
      }

    }
    else {
      res = await _insertEvent(event);
    }

    return res;
  }

  @override
  Future<List<Event?>> getEventsByUserEmail(String email) async {
    final allEvents = await  getAllEvents();
    final res = allEvents.where((element) => element.userEmail == email).toList();
    return res;
  }

  @override
  Future<Event?> getEventById(int id) async {
    final db = await database;
    var res = await  db!.query(Constants.eventsTable, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Event.fromMap(res.first) : null ;
  }

  @override
  Future<List<Event>> getAllEvents() async {
    final db = await database;
    var res = await db!.query(Constants.eventsTable);
    List<Event> list =
    res.isNotEmpty ? res.map((c) => Event.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> _updateEvent(Event existingEvent) async {
    final db = await database;
    var res = await db!.update(Constants.eventsTable, existingEvent.toMap(),
        where: "id = ?", whereArgs: [existingEvent.id]);
    return res;
  }

  Future<int> _insertEvent(Event newEvent) async {
    final db = await database;
    var x = newEvent.toMap();
    var res = await db!.insert(Constants.eventsTable, newEvent.toMap());
    return res;
  }

  @override
  Future<int> deleteEvent(Event event) async {
    // TODO: implement event
    final db = await database;
    var res = await db!.delete('${Constants.eventsTable}', where: 'id=?', whereArgs: [event.id]);
    return res;
  }
}