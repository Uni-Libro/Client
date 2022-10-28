import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/fonts.gen.dart';
import '../local_api.dart';
import 'en_us.dart';
import 'fa_ir.dart';

class LocalizationService extends Translations {
  LocalizationService(String initLang) {
    locale = _getLocale(initLang);
    _changeFontFamily(initLang);
    _changeTextDirection(initLang);
  }

  late final Locale locale;

  static const fallBackLocale = Locale('fa', 'IR');

  static String? fontFamily;

  static TextDirection? textDirection;

  static final langs = [
    'persian',
    'english',
  ];

  static final displayLangs = [
    'فارسی',
    'English',
  ];

  static const locales = [
    Locale('fa', 'IR'),
    Locale('en', 'US'),
  ];

  static const fontFamilies = [
    FontFamily.yekanBakh,
    FontFamily.sFPro,
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'fa_IR': faIR,
        'en_US': enUS,
      };

  static Map<String, TextDirection> get _textDecorations => {
        'fa_IR': TextDirection.rtl,
        'en_US': TextDirection.ltr,
      };

  static void changeLocale(String localeName) {
    LocalAPI().shPref.setString('lang', localeName);
    final locale = _getLocale(localeName);
    _changeFontFamily(localeName);
    _changeTextDirection(localeName);
    Get.updateLocale(locale);
  }

  static void _changeFontFamily(String localeName) {
    try {
      fontFamily = fontFamilies[langs.indexOf(localeName)];
    } catch (e) {
      fontFamily = fontFamilies[0];
    }
  }

  static void _changeTextDirection(String localeName) {
    try {
      textDirection = _textDecorations[_getLocale(localeName).toString()];
    } catch (e) {
      textDirection = _textDecorations[locales[0].toString()];
    }
  }

  static Locale _getLocale(String lang) {
    try {
      return locales[langs.indexOf(lang)];
    } catch (e) {
      return locales[0];
    }
  }
}
