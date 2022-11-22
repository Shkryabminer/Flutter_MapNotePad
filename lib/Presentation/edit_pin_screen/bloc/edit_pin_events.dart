import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Models/pin/pin.dart';

abstract class EditPinEvent
{}

class AddUpdatePinEvent extends EditPinEvent
{
  Pin? pin;
  final String? label;
  final String? description;
  final String? latitude;
  final String? longitude;
  final Function() callBack;
  AddUpdatePinEvent(
      this.pin,
      this.label,
      this.description,
      this.latitude,
      this.longitude,
      this.callBack
      );
}

class InitStateEvent extends EditPinEvent{
  final TextEditingController labelController ;
  final TextEditingController descriptionController ;
  final TextEditingController latitudeController ;
  final TextEditingController longitudeController ;
  Pin? pin;
  InitStateEvent({this.pin,
    required this.labelController,
    required this.descriptionController,
    required this.latitudeController,
    required this.longitudeController
  });
}

class LongPressEvent extends EditPinEvent{
  LatLng coordinates;
  LongPressEvent({required this.coordinates});
}