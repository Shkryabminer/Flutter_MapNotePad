import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditPinsScreenState
{
  String? pinLabelErrorText;
  Set<Marker>? marker;
  String? latitude;
  String? longitude;
  String? label;
  String? description;

      EditPinsScreenState({this.pinLabelErrorText,
      this.marker,
      this.latitude,
      this.label,
      this.longitude,
      this.description});

    EditPinsScreenState copyWith({pinLabelErrorText, marker, latitude,longitude,label,description})
    {
      return EditPinsScreenState(
        pinLabelErrorText: pinLabelErrorText ?? this.pinLabelErrorText,
        marker: marker ?? this.marker,
        label: label ?? this.label,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        description: description ?? this.description
        );
    }
}