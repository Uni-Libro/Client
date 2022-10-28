import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../services/localization/strs.dart';
import '../widgets/bottom_nav_bar/stack_nav_bar.dart';
import '../widgets/my_app_bar/my_app_bar.dart';

class HolderScn extends StatelessWidget {
  const HolderScn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackNavBar(
        body: Scaffold(
          appBar: MyAppBar(),
        ),
        items: _getNavBarItems(),
      ),
    );
  }

  List<StackNavBarItem> _getNavBarItems() {
    return [
      StackNavBarItem(
        icon: Assets.icons.home1TwoTone
            .svg(color: Get.theme.colorScheme.background),
        selectedIcon:
            Assets.icons.home1Bulk.svg(color: Get.theme.colorScheme.background),
        title: Strs.home.tr,
      ),
      StackNavBarItem(
        icon: Assets.icons.searchNormalTwoTone
            .svg(color: Get.theme.colorScheme.background),
        selectedIcon: Assets.icons.searchNormalBulk
            .svg(color: Get.theme.colorScheme.background),
        title: Strs.search.tr,
      ),
      StackNavBarItem(
        icon: Assets.icons.bookTwoTone
            .svg(color: Get.theme.colorScheme.background),
        selectedIcon:
            Assets.icons.bookBulk.svg(color: Get.theme.colorScheme.background),
        title: Strs.library.tr,
      ),
      StackNavBarItem(
        icon: Assets.icons.shoppingCartTwoTone
            .svg(color: Get.theme.colorScheme.background),
        selectedIcon: Assets.icons.shoppingCartBulk
            .svg(color: Get.theme.colorScheme.background),
        title: Strs.cart.tr,
      ),
    ];
  }
}
