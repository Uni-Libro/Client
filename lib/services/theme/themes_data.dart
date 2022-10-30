import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/localization_service.dart';

class ThemesData {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: LocalizationService.fontFamily,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: LocalizationService.fontFamily,
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: LocalizationService.fontFamily,
        ),
    appBarTheme: const AppBarTheme().copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      color: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      color: const Color(0xffFFFFFF),
      surfaceTintColor: const Color(0xffFFFFFF),
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 20,
          cornerSmoothing: 1,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff00AFCE),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffFAFAFA),
    colorScheme: const ColorScheme.light().copyWith(
      background: const Color(0xffFAFAFA),
      onBackground: const Color(0xff192734),
      surface: const Color(0xffFFFFFF),
      onSurface: const Color(0xff16202A),
      primary: const Color(0xffF38138),
      secondary: const Color(0xff00AFCE),
      tertiary: const Color(0xff008001),
      errorContainer: const Color(0xFFF44336).withOpacity(0.5),
    ),
  );
  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: LocalizationService.fontFamily,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: LocalizationService.fontFamily,
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: LocalizationService.fontFamily,
        ),
    appBarTheme: const AppBarTheme().copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      color: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      color: const Color(0xff16202A),
      surfaceTintColor: const Color(0xff16202A),
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 20,
          cornerSmoothing: 1,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff00AFCE),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff192734),
    colorScheme: const ColorScheme.dark().copyWith(
      background: const Color(0xff192734),
      onBackground: const Color(0xffFAFAFA),
      surface: const Color(0xff16202A),
      onSurface: const Color(0xffFFFFFF),
      primary: const Color(0xffF38138),
      secondary: const Color(0xff00AFCE),
      tertiary: const Color(0xff008001),
      errorContainer: const Color(0xFFF44336).withOpacity(0.5),
    ),
  );
}
