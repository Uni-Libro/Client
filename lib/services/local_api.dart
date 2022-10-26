import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/log.dart';

class LocalAPI {
  static late final LocalAPI _instance;

  LocalAPI._initialize(this.shPref, this.secStor)
      : _isFirstRun = shPref.getBool('isFirstRun') ?? true;

  factory LocalAPI([SharedPreferences? shPref, FlutterSecureStorage? secStor]) {
    if (shPref != null && secStor != null) {
      _instance = LocalAPI._initialize(shPref, secStor);
    }
    return _instance;
  }

  final SharedPreferences shPref;
  final FlutterSecureStorage secStor;

  bool _isFirstRun;

  bool get isFirstRun => _isFirstRun;

  set isFirstRun(bool value) {
    // _isFirstRun = value;
    // shPref.setBool('isFirstRun', _isFirstRun);
    logging('Local API -> isFirstRun => $_isFirstRun');
  }
}
