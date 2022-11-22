abstract class LoginEvent{}

class LoginClickEvent extends LoginEvent
{
  final String? email;
  final String? password;
  final Function()? callBack;
  final Function(String)? errorCallback;

  LoginClickEvent(
      this.email,
      this.password,
      this.callBack,
      this.errorCallback
      );
}

class GoogleAuthEvent extends LoginEvent
{
  final Function()? callBack;
  final Function(String)? errorCallback;
  GoogleAuthEvent(
      this.callBack,
      this.errorCallback);
}