import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/events.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_state.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentiation_service_impl.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentication_service.dart';
import 'package:map_note_pad/Services/EventService/event_service.dart';
import 'package:map_note_pad/Services/EventService/event_service_impl.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/PinsService/pin_service_impl.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/constants.dart';

class MainScreenBloc extends Bloc<MainScreenEvents, MainScreenState>
{
  late final PinService _pinService;
  late List<Pin?> pins;
  late List<Event?> events;
  late final SettingsService _settingsService;
  AuthenticationService? _authenticationService;
  late final EventService _eventService;

  MainScreenBloc(MainScreenState initialState) : super(initialState)
  {
    _authenticationService = AuthenticationServiceImpl();
    _pinService = PinServiceImpl.pinService;
    _settingsService = SettingsServiceImpl();
    _eventService = EventServiceImpl.eventService;
    on<PinTapEvent>(OnPinTapEvent);
    on<SearchPinEvent>(OnSearchPinEvent);
    on<TabSelectEvent>(OnTabSelectEvent);
    on<InitStateEvent>(OnInitStateEvent);
    on<DeletePinEvent>(OnDeletePinEvent);
    on<UpdatePinEvent>(_onUpdatePinEvent);
    on<ExitTapEvent>(_onExitTapEvent);
    on<PinScreenTabEvent>(_onPinScreenTabEvent);
    on<EventTapEvent>(_onEventTapEvent);
    on<EventDeleteEvent>(_onEventDeleteEvent);
  }

  FutureOr<void> OnPinTapEvent(PinTapEvent event, Emitter<MainScreenState> emit) async {
    final _cameraPosition = CameraPosition(target: LatLng(event.pin.latitude.toDouble(),event.pin.longitude.toDouble()));
    final markers = getMarkers(pins);
    emit(state.copyWith(pageIndex:0,pinPosition: _cameraPosition, markers: markers));
    //state.pinPosition = null;

    //event.callback?.call(LatLng(event.pin.latitude.toDouble(),event.pin.longitude.toDouble()));
  }

  FutureOr<void> _onEventTapEvent(EventTapEvent event, Emitter<MainScreenState> emit) async{

    if(event.event!= null)
      {
        pins = await _getPins();
        var markers = _getMarkersWihtInfo(pins, event.event);
        var currentPin = await _pinService.getPinById(event.event.pinId);
        
        final location = LatLng(currentPin!.latitude.toDouble(), currentPin!.longitude.toDouble());
        final _cameraPosition = CameraPosition(target: location);
        emit(state.copyWith(markers: markers, pinPosition: _cameraPosition,pageIndex: 0),);
      }
  }

  FutureOr<void> OnSearchPinEvent(SearchPinEvent event, Emitter<MainScreenState> emit) async {

    List<Pin?> _pins = [];
    Set<Marker> markers;
    if(event.searchText.isNotEmpty) {
      final allPins = await _getPins();
        _pins = !allPins.isEmpty ? allPins.where((element) =>
          element!.label.startsWith(event.searchText)).toList() : [];
    }
    else
      {
        _pins = await _getPins();
      }
    markers = getMarkers(_pins);

    emit(state.copyWith(pins: _pins, markers: markers));
  }

  FutureOr<void> OnTabSelectEvent(TabSelectEvent event, Emitter<MainScreenState> emit) {
    emit(state.copyWith(pageIndex:event.pageIndex));
  }

  FutureOr<void> OnInitStateEvent(InitStateEvent event, Emitter<MainScreenState> emit) async{

    //final allPins = await _pinService.getAllPins();
    events = await _getEvents();
    pins  = await _getPins();
    final markers = getMarkers(pins);

    emit(state.copyWith(pins: pins, events: events, markers: markers));
  }

  FutureOr<void> OnDeletePinEvent(DeletePinEvent event, Emitter<MainScreenState> emit) async {
    await _pinService.deletePin(event.pinToDelete);
    var _pins = state.pins;
    _pins?.remove(event.pinToDelete);
    final markers = getMarkers(_pins!);
    emit(state.copyWith(pins: _pins, markers: markers));
  }

  FutureOr<void> _onEventDeleteEvent(EventDeleteEvent event, Emitter<MainScreenState> emit) async {
    await _eventService.deleteEvent(event.eventToDelete);
    var _events = state.events;
    _events?.remove(event.eventToDelete);

    emit(state.copyWith(events: _events));
  }

  Set<Marker> getMarkers(List<Pin?> pins)
  {
    final markers =  pins.map((e) => Marker(markerId:MarkerId(e!.label), position: LatLng(e.latitude.toDouble(), e.longitude.toDouble()), ));
    final markers1 = markers.toList();
    return markers1.toSet();
  }

  Future<List<Event?>> _getEvents() async{
    final email = await _settingsService.getUserEmail();
    final _events = await _eventService.getEventsByUserEmail(email);

    return _events;
  }

  Future<List<Pin?>> _getPins() async
  {
    final email = await _settingsService.getUserEmail();
    final _pins = await _pinService.getPinsByUserEmail(email);

    return _pins;
  }

  FutureOr<void> _onUpdatePinEvent(UpdatePinEvent event, Emitter<MainScreenState> emit) async{
    await _pinService.addOrUpdatePin(event.pin);
  }

  FutureOr<void> _onExitTapEvent(ExitTapEvent event, Emitter<MainScreenState> emit) async{

    await _authenticationService?.logOut();
    event.callBack?.call();
  }

  FutureOr<void> _onPinScreenTabEvent(PinScreenTabEvent event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(tabIndex:event.tabIndex));
  }

  Set<Marker> _getMarkersWihtInfo(List<Pin?> pins, Event event)
  {
    final markers =  pins.map((e) => Marker(markerId:MarkerId(e!.label),
                                            position: LatLng(e.latitude.toDouble(), e.longitude.toDouble()),
                                            infoWindow: event?.pinId == e.id ? InfoWindow(title: event.label) : InfoWindow.noText) );
    final markers1 = markers.toList();
    return markers1.toSet();
  }

}