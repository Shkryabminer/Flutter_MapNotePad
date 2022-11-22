import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenState
{
   Set<Marker>? pins;

  MapScreenState({
    this.pins,
  })
  {
    pins ??= {};

  }

  MapScreenState copyWith({pins})
  {
    return MapScreenState(
        pins:pins ?? this.pins
    );
  }
}