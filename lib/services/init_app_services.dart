import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization/localization_service.dart';
import 'theme/theme_service.dart';
import 'local_api.dart';

Future<void> initAppServices() async {
  LocalAPI(
    await SharedPreferences.getInstance(),
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions:
          IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
    ),
  );
  Get.put(
    LocalizationService(LocalAPI().shPref.getString('lang') ?? 'english'),
  );
  Get.put(ThemeService(
    ThemeMode.values.byName(
      LocalAPI().shPref.getString("themeMode") ?? "system",
    ),
  ));
}

Future<Map<String, dynamic>> setupServices() async {
  return Future.value({'result': true});
}
