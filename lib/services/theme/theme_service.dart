import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../local_api.dart';

class ThemeService {
  late ThemeMode _mode;

  ThemeService(ThemeMode mode) {
    _mode = mode;
  }

  ThemeMode get mode => _mode;

  set mode(ThemeMode themeMode) {
    _mode = themeMode;
    Get.changeThemeMode(mode);

    LocalAPI().themeMode = mode.name;
  }
}
