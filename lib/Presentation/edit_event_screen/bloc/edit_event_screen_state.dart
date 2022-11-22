import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditEventsScreenState
{
  String? eventLabelErrorText;
  Set<Marker>? markers;
  String? date;
  String? time;
  String? label;
  String? dateText;

  EditEventsScreenState({this.eventLabelErrorText,
    this.markers,
    this.label,
    this.date,
    this.time,
  this.dateText});

  EditEventsScreenState copyWith({pinLabelErrorText, markers, date,time,label, dateText})
  {
    return EditEventsScreenState(
        eventLabelErrorText: pinLabelErrorText ?? this.eventLabelErrorText,
        markers: markers ?? this.markers,
        label: label ?? this.label,
        date: date ?? this.date,
        time: time ?? this.time,
      dateText: dateText ?? this.dateText
    );
  }
}