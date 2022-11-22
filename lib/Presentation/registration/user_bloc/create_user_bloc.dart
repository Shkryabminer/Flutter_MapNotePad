import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_note_pad/Helpers/validation_helper.dart';
import 'package:map_note_pad/Models/User/user.dart';
import 'package:map_note_pad/Presentation/registration/user_bloc/create_user_event.dart';
import 'package:map_note_pad/Presentation/registration/user_bloc/create_user_state.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/UserService/user_service.dart';

class CreateUserBloc extends Bloc<UserEvent,CreateUserState>
{
   UserService? _userService;
   SettingsService? _settingsService;

  CreateUserBloc() : super(initialState())
  {
    _settingsService = SettingsServiceImpl();
    _userService = UserService.userService;
    on<CreateUserEvent>(_onCreatUserClick);
    on<GoogleSignInEvent>(_onGoogleSignInEvent);
  }

   static CreateUserState initialState() => CreateUserState(null, null, null, null);

  FutureOr<void> _onCreatUserClick(CreateUserEvent event, Emitter<CreateUserState> emit) async {

    final isPasswordValid = ValidationHelper.validatePassword(event.password!);

    if(isPasswordValid && event.confirmPassword == event.password)
      {
        final user = User(email: event.email, name: event.login, password: event.password!);
        final userId =  await _userService!.addOrUpdateUser(user);
        await _settingsService?.setUserEmail(user.email);
        if(event.callback != null)
          {
            event.callback!();
          }
      }
    else
      {

        emit(CreateUserState(null,null, _getPasswordError(isPasswordValid),
         _getConfirmPasswordError(event.password!, event.confirmPassword)));
      }
  }

   String? _getPasswordError(bool isPasswordValid) {
     return isPasswordValid ? null : 'Password should have at least 6 symbols and contain at least 1 digit and 1 letter';
   }

   String? _getConfirmPasswordError(String password, String? confirmPassword) {
     return password == confirmPassword ? null : 'Password mismatch';
   }

   FutureOr<void> _onGoogleSignInEvent(GoogleSignInEvent event, Emitter<CreateUserState> emit) async{
     try {
       var gsa = await GoogleSignIn().signIn();
       var email = gsa?.email;

       if(email != null)
       {
         final currentUser = await _getUserByEmail(email);

         if(currentUser == null)
         {
           var newUser = User(name: '', email: email, password: '', authorizationType: AuthorizationType.google);
           await _userService?.addOrUpdateUser(newUser);
           await _settingsService?.setUserEmail(newUser.email);
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