import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'screens/holder_screen.dart';
import 'screens/on_boarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'services/init_app_services.dart';
import 'services/local_api.dart';
import 'services/localization/localization_service.dart';
import 'services/localization/strs.dart';
import 'services/theme/theme_service.dart';
import 'services/theme/themes_data.dart';
import 'widgets/loading_widget.dart/loading_widget.dart';

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
      title: Strs.appName.tr,
      home: const ScreenApp(),
    );
  }
}

class ScreenApp extends StatelessWidget {
  const ScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0),
      body: Builder(builder: (context) {
        if (LocalAPI().isFirstRun) {
          return const OnBoardingScn();
        }
        return FutureBuilder(
          future: setupServices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if ((snapshot.data as Map<String, dynamic>)['result'] as bool) {
                return const HolderScn();
              } else {
                return const SignInScn();
              }
            } else {
              return const SplashScn();
            }
          },
        );
      }),
    );
  }
}

class SplashScn extends StatelessWidget {
  const SplashScn({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingWidget();
  }
}
