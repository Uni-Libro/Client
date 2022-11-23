import 'package:flutter/material.dart';

import '../services/localization/localization_service.dart';

Size calcTextSize(Text widget, [double? maxWidth]) {
  final textPainter = TextPainter(
    text: TextSpan(text: widget.data, style: widget.style),
    maxLines: widget.maxLines,
    textDirection: widget.textDirection ?? LocalizationService.textDirection,
  )..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
  return textPainter.size;
}
