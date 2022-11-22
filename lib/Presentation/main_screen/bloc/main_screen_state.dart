import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Models/pin/pin.dart';

class MainScreenState
{
  Set<Marker>? markers;
  List<Pin>? pins;
  int pageIndex;
  int tabIndex;
  CameraPosition? pinPosition;
  List<Event>? events;

  MainScreenState({
    this.markers,
    this.pins,
    this.pageIndex = 0,
    this.tabIndex = 0,
   this.pinPosition,
    this.events
  })
  {
    markers ??= {};
  }

  MainScreenState copyWith({markers, pins,events, pageIndex, pinPosition, tabIndex})
  {
    return MainScreenState(
        markers:markers ?? this.markers,
        pins:pins ?? this.pins,
        pageIndex: pageIndex ?? this.pageIndex,
        pinPosition:  pinPosition ?? this.pinPosition,
        tabIndex: tabIndex ?? this.tabIndex,
        events: events ?? this.events
    );
  }
}