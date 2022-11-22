import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentication_service.dart';
import 'package:map_note_pad/Services/SettingsService/settings_service_impl.dart';
import 'package:map_note_pad/constants.dart';

class AuthenticationServiceImpl implements AuthenticationService
{
  final SettingsServiceImpl _settingsService = SettingsServiceImpl();

  @override
  Future<bool> get isAuthorised async {
    final userEmail = await _settingsService.getUserEmail();
    return  userEmail != Constants.isUnlogined;
  }

  @override
  Future<void> logOut() async{
    await _settingsService.setUserEmail(Constants.isUnlogined);
    var gsa = await GoogleSignIn().signOut();
  }



}