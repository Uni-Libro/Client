import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/log.dart';

class LocalAPI {
  static late final LocalAPI _instance;

  LocalAPI._initialize(this._shPref, this._secStor)
      //   : _isFirstRun = false,
      //     _isShowAnimation = true,
      //     _themeMode = 'system',
      //     _language = 'english';
      : _isFirstRun = _shPref.getBool('isFirstRun') ?? true,
        _isShowAnimation = _shPref.getBool('isShowAnimation') ?? true,
        _themeMode = _shPref.getString('themeMode') ?? 'system',
        _language = _shPref.getString('language') ?? 'english';

  factory LocalAPI([SharedPreferences? shPref, FlutterSecureStorage? secStor]) {
    if (shPref != null && secStor != null) {
      _instance = LocalAPI._initialize(shPref, secStor);
    }
    return _instance;
  }

  final SharedPreferences _shPref;
  final FlutterSecureStorage _secStor;

  bool _isFirstRun;
  bool _isShowAnimation;
  String _themeMode;
  String _language;

  bool get isFirstRun => _isFirstRun;
  bool get isShowAnimation => _isShowAnimation;
  String get themeMode => _themeMode;
  String get language => _language;

  set isFirstRun(bool value) {
    _isFirstRun = value;
    _shPref.setBool('isFirstRun', _isFirstRun);
    logging('Local API -> isFirstRun => $_isFirstRun');
  }

  set isShowAnimation(bool value) {
    _isShowAnimation = value;
    _shPref.setBool('isShowAnimation', _isShowAnimation);
    logging('Local API -> isShowAnimation => $_isShowAnimation');
  }

  set themeMode(String value) {
    _themeMode = value;
    _shPref.setString('themeMode', _themeMode);
    logging('Local API -> themeMode => $_themeMode');
  }

  set language(String value) {
    _language = value;
    _shPref.setString('language', _language);
    logging('Local API -> language => $_language');
  }
}
