import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

class SearchScn extends StatelessWidget {
  const SearchScn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Strs.search.tr,
          style: Get.textTheme.headline5,
        ),
      ),
    );
  }
}
