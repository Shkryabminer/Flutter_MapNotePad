import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_events.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_screen_state.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/PinsService/pin_service_impl.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';

class EditPinScreenBloc extends Bloc<EditPinEvent, EditPinsScreenState>
{

  PinService? _pinService;
  SettingsServiceImpl? _settingsService;

  EditPinScreenBloc (EditPinsScreenState initialState) : super(initialState)
  {
    _pinService = PinServiceImpl.pinService;
    _settingsService = SettingsServiceImpl();
    on<AddUpdatePinEvent>(_onAddUpdatePin);
    on<LongPressEvent>(_onLongPressEvent);
    on<InitStateEvent>(_onInitStatePin);
  }

  FutureOr<void> _onAddUpdatePin(AddUpdatePinEvent event, Emitter<EditPinsScreenState> emit) async {
    if(event.pin != null)
      {
        event.pin!.label = event.label!;
        event.pin!.longitude =  num.tryParse(event.longitude!)!;
        event.pin!.latitude =  num.tryParse(event.latitude!)!;
        event.pin!.description = event.description!;
        final pin = event.pin!;
        await _pinService?.addOrUpdatePin(pin);
      }
    else
      {
        final userEmail = await _settingsService?.getUserEmail();
        var pin = Pin( userEmail: userEmail!,
            longitude: num.tryParse(event.longitude!)!,
            latitude: num.tryParse(event.latitude!)!,
            label: event.label!,
            description: event.description ?? '',
            isFavorite: false);

        await _pinService?.addOrUpdatePin(pin);
      }

    event.callBack?.call();
  }

  FutureOr<void> _onLongPressEvent(LongPressEvent event, Emitter<EditPinsScreenState> emit) {
    final marker = Marker(markerId: MarkerId("marker"), position: event.coordinates);
     var markers = Set<Marker>();
    markers.add(marker);

    emit(state.copyWith(marker: markers));
  }

  FutureOr<void> _onInitStatePin(InitStateEvent event, Emitter<EditPinsScreenState> emit) {
    if(event.pin != null)
      {
        LatLng coordinates= LatLng(event.pin!.latitude.toDouble(), event.pin!.longitude.toDouble());
          event.labelController.text = event.pin!.label;
          event.descriptionController.text = event.pin!.description ??'';
          event.latitudeController.text = event.pin!.latitude.toString();
          event.longitudeController.text = event.pin!.longitude.toString();

        emit(state.copyWith(
          label: event.pin!.label,
          latitude: event.pin!.latitude.toString(),
          longitude: event.pin!.longitude.toString(),
          marker: Set<Marker>()..add( Marker(markerId:MarkerId(''), position: coordinates))
        ));
      }
  }
}