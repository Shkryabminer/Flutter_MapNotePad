import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_note_pad/Models/User/user.dart';
import 'package:map_note_pad/Presentation/login/bloc/login_event.dart';
import 'package:map_note_pad/Presentation/login/bloc/login_state.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/UserService/user_serice_interface.dart';
import 'package:map_note_pad/Services/UserService/user_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>
{
  IUserService? _userService;
  SettingsService? _settingsService;
  LoginBloc() : super(initState())
  {
    _settingsService = SettingsServiceImpl();
    _userService = UserService.userService;

    on<LoginClickEvent>(_onLoginClick);
    on<GoogleAuthEvent>(_onGoogleAuthEvent);
  }

  static LoginState initState() => LoginState(null, null);

  FutureOr<void> _onLoginClick(LoginClickEvent event, Emitter<LoginState> emit) async {

    final allUsers = await _userService?.getAllUsers();
    final matchUsers = allUsers?.where((element) => element.email == event.email &&
    element.authorizationType == AuthorizationType.local);

    if(matchUsers!.isNotEmpty)
      {
        final currentUser = matchUsers.first;
        if(currentUser.password == event.password){
         _settingsService?.setUserEmail(currentUser.email);
        event.callBack!();
        }
        else {
          emit(LoginState(null, 'Incorrect password'));
          }
      }
    else{
      emit(LoginState('Wrong email', null));
    }
  }

  FutureOr<void> _onGoogleAuthEvent(GoogleAuthEvent event, Emitter<LoginState> emit) async {

    try {
      var gsa = await GoogleSignIn().signIn();
      var email = gsa?.email;

      if(email != null)
        {
          final currentUser = await _getUserByEmail(email);

          if(currentUser != null)
            {
             await _settingsService?.setUserEmail(currentUser.email);
             event.callBack?.call();
            }
          else
            {
              event.errorCallback?.call("Try other type of login or other account.");
            }
        }

      await GoogleSignIn().signOut();
    }
    catch (exception)
    {}
  }

  Future<User?> _getUserByEmail(String email) async
  {
    User? currentUser;
    List<User?> matchedUsers = [];
    final users = await _userService?.getAllUsers();
     users?.forEach((element) {
       if(element.email == email &&
         element.authorizationType == AuthorizationType.google)
     {
       matchedUsers.add(element);
     }; });
      if(matchedUsers.isNotEmpty)
        {
          currentUser = matchedUsers.first;
        }

    return currentUser;
  }
}