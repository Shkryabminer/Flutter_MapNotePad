abstract class AuthenticationService
{
 Future<bool> get isAuthorised;
 Future<void> logOut();
}