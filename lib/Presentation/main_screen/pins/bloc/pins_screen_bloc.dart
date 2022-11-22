import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/bloc/pins_screen_state.dart';
import 'package:map_note_pad/Services/PinsService/pin_service.dart';
import 'package:map_note_pad/Services/PinsService/pin_service_impl.dart';

import 'events.dart';

class PinsScreenBloc extends Bloc<PinEvents, PinsScreenState>
{
  late final PinService _pinService;
  PinsScreenBloc(PinsScreenState initialState) : super(initialState)
  {
    _pinService = PinServiceImpl.pinService;
    on<InitPinStateEvent>(_onInitStateEvent);
    on<SearchPinEvent>(_onSearchPinEvent);
  }

  FutureOr<void> _onInitStateEvent(InitPinStateEvent event, Emitter<PinsScreenState> emit) async {
    //final _pins = await _pinService.getAllPins();
   final _pins  = [];
    emit(state.copyWith(pins: _pins));
  }

  FutureOr<void> _onSearchPinEvent(SearchPinEvent event, Emitter<PinsScreenState> emit) async {
    //var _pins = await _pinService.getAllPins();
    var _pins = state.pins!;
    if(event.searchText.isNotEmpty)
      {
        _pins = _pins.where((element) => element.label.startsWith(event.searchText)).toList();
      }

    emit(state.copyWith(pins: _pins));
  }
}
