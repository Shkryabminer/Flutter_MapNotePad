abstract class SettingsService
{
  Future<String> getUserEmail();
  Future setUserEmail(String email);
}