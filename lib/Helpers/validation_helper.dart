class ValidationHelper
{
 static RegExp _emeilRegExp = RegExp(r'^[a-zA-Z0-9]{1,64}@[a-zA-Z0-9]{0,64}');
 static RegExp _loginRegExp =  RegExp(r'^[a-zA-Z0-9]{1,20}');
 //static RegExp _passwordRegExp = RegExp(r'^[a-zA-Z0-9]{6,20}[a-z]{1,}[A-Z]{1,}[0-9]{1,}');
 static RegExp _passwordRegExp =  RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');

 static bool validateEmail(String email)
  {
    return _emeilRegExp.hasMatch(email);
  }
 static bool validateLogin(String login)
  {
    return _loginRegExp.hasMatch(login);
  }
  static bool validatePassword(String password)
  {
    return _passwordRegExp.hasMatch(password);
  }

}