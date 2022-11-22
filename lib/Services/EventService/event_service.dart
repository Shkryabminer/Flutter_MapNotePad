import 'package:map_note_pad/Models/event/event.dart';

abstract class EventService {
  Future<List<Event>> getAllEvents();

  Future<List<Event?>> getEventsByUserEmail(String email);

  Future<Event?> getEventById(int id);

  Future<int> addOrUpdateEvent(Event event);

  Future<int> deleteEvent(Event event);
}