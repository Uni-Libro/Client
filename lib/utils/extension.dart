import 'package:flutter/material.dart';

import '../services/localization/localization_service.dart';

const List<String> _englishNums = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '%'
];
const List<String> _persianNums = [
  '۰',
  '۱',
  '۲',
  '۳',
  '۴',
  '۵',
  '۶',
  '۷',
  '۸',
  '۹',
  '٪'
];

extension StringExtraExtension on String {
  String _toPersianNums() {
    String result = this;
    for (int i = 0; i < _englishNums.length; i++) {
      result = result.replaceAll(_englishNums[i], _persianNums[i]);
    }
    return result;
  }

  String trNums() {
    if (LocalizationService.textDirection == TextDirection.rtl) {
      return _toPersianNums();
    } else {
      return this;
    }
  }
}
