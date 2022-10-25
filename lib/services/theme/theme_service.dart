import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user_service.dart';

class ThemeService {
  late ThemeMode _mode;

  ThemeService(ThemeMode mode) {
    _mode = mode;
  }

  ThemeMode get mode => _mode;

  set mode(ThemeMode themeMode) {
    _mode = themeMode;
    Get.changeThemeMode(mode);

    // Future.delayed(
    //     const Duration(milliseconds: 500), (() => Get.changeThemeMode(mode)));
    UserService.shPref.setString("themeMode", _mode.name);
  }
}
