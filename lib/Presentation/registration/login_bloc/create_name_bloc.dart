
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_note_pad/Helpers/validation_helper.dart';
import 'package:map_note_pad/Models/User/user.dart';
import 'package:map_note_pad/Presentation/registration/login_bloc/create_name_state.dart';
import 'package:map_note_pad/Presentation/registration/login_bloc/create_name_event.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/Services/UserService/user_serice_interface.dart';
import 'package:map_note_pad/Services/UserService/user_service.dart';

class CreateNameBloc extends Bloc<RegistrationEvent, CreateNameState>
{
  IUserService? _userService;
  SettingsService? _settingsService;
  CreateNameBloc() : super(initState())
  {
    _settingsService = SettingsServiceImpl();
    _userService = UserService.userService;
    on<CreateNameEvent>(_onLoginClicked);
    on<GoogleSignInEvent>(_onGoogleSignInEvent);
  }

  static CreateNameState initState() => CreateNameState(null, null, null, null);

  FutureOr<void> _onLoginClicked(CreateNameEvent event, Emitter<CreateNameState> emit) async {
    final isLoginValid = ValidationHelper.validateLogin(event.login);
    final isEmailValid = ValidationHelper.validateEmail(event.email);
    final allUsers = await _userService?.getAllUsers();
    final existingUsers = allUsers?.where((element) =>
    element.name == event.login);

    if(existingUsers!=null && existingUsers.isNotEmpty)
      {
        emit(CreateNameState('User is already existed',null,null,null));
      }
    else if(isLoginValid && isEmailValid ) {
      event.callback!();
    } else {
      emit(CreateNameState(_getLoginError(isLoginValid),_getEmailError(isEmailValid),null,null));
    }
  }

  String? _getLoginError(bool isLoginValid) {
    return isLoginValid ? null : 'Login should be from 6 to 20 symbols and consist from letters and digits';
  }

  String? _getEmailError(bool isEmailValid) {
    return isEmailValid ? null : 'Wrong email';
  }

  FutureOr<void> _onGoogleSignInEvent(GoogleSignInEvent event, Emitter<CreateNameState> emit) async{
    try {
      var gsa = await GoogleSignIn().signIn();
    var ff = GoogleSignIn.standard();
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