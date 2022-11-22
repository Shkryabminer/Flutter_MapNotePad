
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class RegistrationEvent {}

class CreateNameEvent extends RegistrationEvent
{
  final String login;
  final String email;
  final Function()?  callback;
   CreateNameEvent(
      @required this.login,
      @required this.email,
       this.callback
      );
}
class GoogleSignInEvent extends RegistrationEvent
{
  final Function()? callBack;
  final Function(String)? errorCallback;
  GoogleSignInEvent(
      this.callBack,
      this.errorCallback);
}