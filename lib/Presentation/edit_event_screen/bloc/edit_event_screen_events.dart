import 'package:flutter/widgets.dart';
import 'package:map_note_pad/Models/event/event.dart';

abstract class EditEventScreenEvent
{}

class AddUpdateEvent_Event extends EditEventScreenEvent
{
  Event? event;
  final String? label;
  final String dateTime;
  final Function() callBack;
  AddUpdateEvent_Event(
      this.event,
      this.label,
      this.dateTime,
      this.callBack
      );
}

class DateTapEvent extends EditEventScreenEvent
{}

class InitStateEvent extends EditEventScreenEvent{
  final TextEditingController labelController ;
  final TextEditingController dateTimeController ;
  Event? event;
  InitStateEvent({this.event,
    required this.labelController,
    required this.dateTimeController
  });
}

class LongPressEvent extends EditEventScreenEvent{
  LongPressEvent();
}