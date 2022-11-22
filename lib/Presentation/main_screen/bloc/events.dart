import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Models/pin/pin.dart';

abstract class MainScreenEvents
{}

class SearchPinEvent extends MainScreenEvents
{
  final String searchText;
  SearchPinEvent(
      this.searchText
      );
}

class InitStateEvent extends MainScreenEvents
{
  InitStateEvent();
}

class PinTapEvent extends MainScreenEvents
{
  final Pin pin;

  PinTapEvent(
      this.pin,
      );
}

class EventTapEvent extends MainScreenEvents
{
  final Event event;

  EventTapEvent(
      this.event,
      );
}

class TabSelectEvent extends MainScreenEvents
{
 final int pageIndex;
  TabSelectEvent(this.pageIndex);
}

class DeletePinEvent extends MainScreenEvents{
  final Pin pinToDelete;
  DeletePinEvent(this.pinToDelete);
}

class EventDeleteEvent extends MainScreenEvents{
  final Event eventToDelete;
  EventDeleteEvent(this.eventToDelete);
}

class UpdatePinEvent extends MainScreenEvents
{
  final Pin pin;

  UpdatePinEvent(
      this.pin,
      );
}
class ExitTapEvent extends MainScreenEvents
{
  final Function()? callBack;
  ExitTapEvent({this.callBack});
}
class PinScreenTabEvent extends MainScreenEvents
{
  final int tabIndex;
  PinScreenTabEvent(this.tabIndex);
}