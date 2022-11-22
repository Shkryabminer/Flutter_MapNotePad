
import 'package:flutter/cupertino.dart';

abstract class UserEvent{}

class CreateUserEvent extends UserEvent{

  String login;
  String email;
  String? password;
  String? confirmPassword;
  final Function()?  callback;

   CreateUserEvent(
       this.login,
      this.email,
      this.password,
      this.confirmPassword,
       this.callback
      );
}
class GoogleSignInEvent extends UserEvent
{
  final Function()? callBack;
  final Function(String)? errorCallback;
  GoogleSignInEvent(
      this.callBack,
      this.errorCallback);
}