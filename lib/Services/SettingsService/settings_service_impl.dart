import 'package:map_note_pad/Services/SettingsService/settings_service.dart';
import 'package:map_note_pad/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsServiceImpl implements SettingsService
{
  final  preferences =  SharedPreferences.getInstance();

  @override
  Future<String> getUserEmail() async {
    final prefs = await preferences;
    return  prefs.getString(Constants.userIdKey) ?? Constants.isUnlogined;
  }

  @override
  Future setUserEmail(String email) async {
    final prefs = await preferences;
   await prefs.setString(Constants.userIdKey, email);
  }

}