import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_note_pad/Presentation/greeting/greeting_screen.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentiation_service_impl.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentication_service.dart';
import 'package:map_note_pad/application/bloc/application_event.dart';
import 'package:map_note_pad/application/bloc/application_state.dart';
import 'package:map_note_pad/constants.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState>
{
  ApplicationBloc() : super(ApplicationState())
  {
    on<ApplicationInitStateEvent>(_initApplicationState);
  }


  FutureOr<void> _initApplicationState(ApplicationInitStateEvent event, Emitter<ApplicationState> emit) async {
    final AuthenticationService authenticationService = AuthenticationServiceImpl();
    final _isAuthenticated = await authenticationService.isAuthorised;
    final initialRoute = _isAuthenticated ? MainScreen() : GreetingScreen();

    emit(state.copyWith(initialRoute: initialRoute));
  }
}