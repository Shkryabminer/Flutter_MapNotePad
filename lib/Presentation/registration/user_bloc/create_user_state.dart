class CreateUserState
{
   String? errorPasswordText;
   String? errorConfirmPasswordText;
   String? password;
   String? confirmPassword;

  CreateUserState(this.password,
      this.confirmPassword,
      this.errorPasswordText,
      this.errorConfirmPasswordText);
}