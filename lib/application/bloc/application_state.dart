import 'package:flutter/material.dart';

class ApplicationState
{
final Widget? initialRoute;
ApplicationState({
  this.initialRoute
});

  ApplicationState copyWith({initialRoute})
  {
    return ApplicationState(
      initialRoute: initialRoute ?? this.initialRoute
    );
  }
}