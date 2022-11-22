

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/map/bloc/events.dart';
import 'package:map_note_pad/Presentation/main_screen/map/bloc/map_screen_state.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/PinsService/pin_service_impl.dart';

class MapScreenBloc extends Bloc<MapEvent, MapScreenState>
{
  late PinService _pinService;
  MapScreenBloc(MapScreenState initialState) : super(initialState)
  {
    _pinService = PinServiceImpl.pinService;
    on<SearchPinEvent>(onSearchPin);

  }


  FutureOr<void> onSearchPin(SearchPinEvent event, Emitter<MapScreenState> emit) async {
    final pins = await _pinService.getAllPins();

    final currentPins = pins.where((element) => element.label.startsWith(event.pinTitle) );
    if(currentPins.isNotEmpty)
      {
        final currentPin = currentPins.first;
        event.callBack(currentPin.longitude, currentPin.latitude);
      }
  }

}