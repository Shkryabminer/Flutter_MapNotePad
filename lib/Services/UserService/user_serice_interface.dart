import 'package:map_note_pad/Models/User/user.dart';

abstract class IUserService
{
 Future<List<User>> getAllUsers();
 Future<User?> getUserById(int id);
 Future<int> addOrUpdateUser(User user);
}