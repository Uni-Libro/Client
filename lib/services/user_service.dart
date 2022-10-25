import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService._();

  static late final SharedPreferences shPref;
  static late final FlutterSecureStorage secStor;
}
