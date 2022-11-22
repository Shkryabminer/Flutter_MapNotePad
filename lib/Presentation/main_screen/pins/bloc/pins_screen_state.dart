import 'package:map_note_pad/Models/pin/pin.dart';

class PinsScreenState
{
  List<Pin>? pins;
  PinsScreenState({
     this.pins
}){
    if(pins == null)
      {
        pins = [];
      }
  }

  PinsScreenState copyWith({pins})
  {
      return PinsScreenState(
        pins:pins ?? this.pins
      );
}
}