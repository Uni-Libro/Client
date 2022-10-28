import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

class HomeScn extends StatelessWidget {
  const HomeScn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Strs.home.tr,
          style: Get.textTheme.headline5,
        ),
      ),
    );
  }
}
