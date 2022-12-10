import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

class SearchScn extends StatelessWidget {
  const SearchScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Text(
          Strs.searchScreenIsOnDev.tr,
          style: Get.textTheme.headline5,
        ),
      ),
    );
  }
}
