import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

void showSnackbar(
  String message, {
  Duration duration = (const Duration(seconds: 3)),
  Color? color,
  SnackPosition position = SnackPosition.BOTTOM,
  MessageType messageType = MessageType.warning,
}) {
  String? title;
  final ContentType type = (() {
    switch (messageType) {
      case MessageType.success:
        title = Strs.successful;
        return ContentType.success;
      case MessageType.error:
        title = Strs.failed;
        return ContentType.failure;
      case MessageType.warning:
        title = Strs.warning;
        return ContentType.warning;
      default:
        return ContentType.help;
    }
  }());

  Get.showSnackbar(
    GetSnackBar(
      snackPosition: position,
      isDismissible: false,
      messageText: AwesomeSnackbarContent(
        title: title?.tr ?? '',
        message: message,
        contentType: type,
      ),
      duration: duration,
      borderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
  );
}

enum MessageType {
  success,
  error,
  warning,
}
