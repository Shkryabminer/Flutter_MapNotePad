import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/edit_event_screen/bloc/edit_event_screen_events.dart';
import 'package:map_note_pad/Presentation/edit_event_screen/bloc/edit_event_screen_state.dart';
import 'package:map_note_pad/Services/EventService/event_service.dart';
import 'package:map_note_pad/Services/EventService/event_service_impl.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/PinsService/pin_service_impl.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';

class EditEventsScreenBloc extends Bloc<EditEventScreenEvent, EditEventsScreenState>
{
  late PinService _pinService;
  late SettingsService _settingsService;
  late EventService _eventService;

  Pin? pin;
  DateTime? dateTime;
  String? label;

  EditEventsScreenBloc (EditEventsScreenState initialState) : super(initialState)
  {
    _pinService = PinServiceImpl.pinService;
    _settingsService = SettingsServiceImpl();
    _eventService = EventServiceImpl.eventService;
    on<AddUpdateEvent_Event>(_onAddUpdateEvent);
    on<DateTapEvent>(_onDateTapEvent);
    on<LongPressEvent>(_onLongPressEvent);
    on<InitStateEvent>(_onInitStateEvent);
  }

  FutureOr<void> _onAddUpdateEvent(AddUpdateEvent_Event _event, Emitter<EditEventsScreenState> emit) async {
    if(_event.event != null)
    {
      _event.event!.label = _event.label!;
      final event = _event.event!;
      await _eventService.addOrUpdateEvent(event);
    }
    else
    {
      if(pin !=null && dateTime != null){
        final date = '${dateTime!.year}.${dateTime!.month}. ${dateTime!.day}';
        final time = '${dateTime!.hour}:${dateTime!.minute}';

      var event = Event( userEmail: pin!.userEmail,
          label: _event.label!,
          pinId: pin!.id!,
        date: date,
        time: time);

      await _eventService?.addOrUpdateEvent(event);
      }
    }

    _event.callBack?.call();
  }

  FutureOr<void> _onLongPressEvent(LongPressEvent event, Emitter<EditEventsScreenState> emit) {
    // final marker = Marker(markerId: MarkerId("marker"), position: event.coordinates);
    // var markers = Set<Marker>();
    // markers.add(marker);
    //
    // emit(state.copyWith(marker: markers));
  }

  FutureOr<void> _onInitStateEvent(InitStateEvent event, Emitter<EditEventsScreenState> emit) async {

    if(event.event != null)
    {
       event.labelController.text = event.event!.label;
       var _datetime = event.event!.date!+event.event!.time!;
       event.dateTimeController.text = _datetime;
    }

    var pins = await _getPins();
    var markers = getMarkers(pins);

    emit(state.copyWith(
        label: event.event?.label,
        markers: markers));
  }

  Set<Marker> getMarkers(List<Pin?> pins)
  {
    final markers =  pins.map((e) =>
        Marker(markerId:MarkerId(e!.label),
        position: LatLng(e.latitude.toDouble(), e.longitude.toDouble()),
        infoWindow: InfoWindow(title:e.label!),
        onTap: (){pin = e;}));

    final markers1 = markers.toList();
    return markers1.toSet();
  }

  Future<List<Pin?>> _getPins() async
  {
    final email = await _settingsService.getUserEmail();
    final _pins = await _pinService.getPinsByUserEmail(email!);

    return _pins;
  }


  FutureOr<void> _onDateTapEvent(DateTapEvent event, Emitter<EditEventsScreenState> emit) async {
     dateTime = DateTime.now().toLocal();
    var text = "${dateTime!.year}.${dateTime!.month}.${dateTime!.day} ${dateTime!.hour}:${dateTime!.minute}";
    emit(state.copyWith(dateText: text));
  }
}