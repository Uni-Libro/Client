import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

class LibraryScn extends StatelessWidget {
  const LibraryScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Text(
          Strs.library.tr,
          style: Get.textTheme.headline5,
        ),
      ),
    );
  }
}
