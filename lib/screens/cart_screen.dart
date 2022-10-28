import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/localization/strs.dart';

class CartScn extends StatelessWidget {
  const CartScn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Strs.cart.tr,
          style: Get.textTheme.headline5,
        ),
      ),
    );
  }
}
