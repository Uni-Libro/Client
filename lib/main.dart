import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uni_libro/services/theme/themes_data.dart';

import 'services/init_app_services.dart';
import 'services/localization/localization_service.dart';
import 'services/localization/strs.dart';
import 'services/theme/theme_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await initAppServices();
  runApp(const MainMaterial());
}

class MainMaterial extends StatelessWidget {
  const MainMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalizationService localizationService = Get.find();
    final ThemeService themeController = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localizationService.locale,
      fallbackLocale: LocalizationService.fallBackLocale,
      translations: localizationService,
      textDirection: LocalizationService.textDirection,
      themeMode: themeController.mode,
      theme: ThemesData.lightTheme,
      darkTheme: ThemesData.darkTheme,
      title: Strs.appName,
      home: const ScreenApp(),
    );
  }
}

class ScreenApp extends StatelessWidget {
  const ScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: setupServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if ((snapshot.data as Map<String, dynamic>)['result'] as bool) {
              return const Scaffold();
            } else {
              return const Scaffold();
            }
          } else {
            return const Scaffold();
          }
        },
      ),
    );
  }
}
