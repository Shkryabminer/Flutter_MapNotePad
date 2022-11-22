import 'package:map_note_pad/Models/pin/pin.dart';

abstract class PinService {
  Future<List<Pin>> getAllPins();

  Future<List<Pin?>> getPinsByUserEmail(String email);

  Future<Pin?> getPinById(int id);

  Future<int> addOrUpdatePin(Pin pin);

  Future<int> deletePin(Pin pin);
}