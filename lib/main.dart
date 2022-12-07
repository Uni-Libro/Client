import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'assets/assets.gen.dart';
import 'screens/holder_screen.dart';
import 'screens/on_boarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'services/init_app_services.dart';
import 'services/local_api.dart';
import 'services/localization/localization_service.dart';
import 'services/localization/strs.dart';
import 'services/theme/theme_service.dart';
import 'services/theme/themes_data.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
      theme: ThemesData.lightTheme.copyWith(
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: LocalizationService.fontFamily,
              ),
          primaryTextTheme: ThemeData.light().textTheme.apply(
                fontFamily: LocalizationService.fontFamily,
              )),
      darkTheme: ThemesData.darkTheme.copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: LocalizationService.fontFamily,
              ),
          primaryTextTheme: ThemeData.dark().textTheme.apply(
                fontFamily: LocalizationService.fontFamily,
              )),
      title: Strs.appName.tr,
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
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
      body: Builder(
        builder: (context) {
          //   FlutterNativeSplash.remove();
          if (LocalAPI().isFirstRun) {
            // FlutterNativeSplash.remove();
            return const OnBoardingScn();
          }
          return FutureBuilder(
            future: setupServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final Widget child;
                if ((snapshot.data as Map<String, dynamic>)['isSignIn']
                    as bool) {
                  child = const HolderScn();
                } else {
                  child = const SignInScn();
                }

                // FlutterNativeSplash.remove();
                return child;
              } else {
                return const SplashScn();
              }
            },
          );
        },
      ),
    );
  }
}

class SplashScn extends StatelessWidget {
  const SplashScn({super.key});

  static const initScale = 0.65;
  static const startScale = initScale - 0.1;
  static const endScale = initScale + 0.1;
  static const startCurve = Curves.bounceOut;
  static const endCurve = Curves.easeIn;
  static const duration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final state = 1.obs;
    Future.delayed(const Duration(milliseconds: 500), () {
      state.value = 2;
    });
    return SizedBox.expand(
      child: Obx(
        () => AnimatedScale(
          scale: () {
            switch (state.value) {
              case 0:
                return startScale;
              case 2:
                return endScale;
              default:
                return initScale;
            }
          }(),
          duration: duration,
          curve: () {
            switch (state.value) {
              case 0:
                return startCurve;
              case 2:
                return endCurve;
              default:
                return startCurve;
            }
          }(),
          child: Assets.dakkeLogoSplash.image(),
          onEnd: () => state.value == 0 ? state.value = 2 : state.value = 0,
        ),
      ),
    );
  }
}
