import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(
  String message, {
  Duration duration = (const Duration(seconds: 4)),
  Color? color,
  SnackPosition position = SnackPosition.BOTTOM,
  MessageType messageType = MessageType.warning,
}) {
  Color bgColor;
  switch (messageType) {
    case MessageType.success:
      bgColor = Colors.green;
      break;
    case MessageType.error:
      bgColor = Colors.red;
      break;
    case MessageType.warning:
      bgColor = Colors.amber;
      break;
  }
  if (color != null) {
    bgColor = color;
  }
  Get.showSnackbar(
    GetSnackBar(
      snackPosition: position,
      isDismissible: false,
      messageText: Container(
        decoration: ShapeDecoration(
          color: bgColor,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 15,
              cornerSmoothing: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: Get.theme.textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
      duration: duration,
      borderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 30),
    ),
  );
}

enum MessageType {
  success,
  error,
  warning,
}
