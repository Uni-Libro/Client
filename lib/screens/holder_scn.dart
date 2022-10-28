import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../services/localization/strs.dart';
import '../widgets/bottom_nav_bar/stack_nav_bar.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';

class HolderScn extends HookWidget {
  const HolderScn({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    return Scaffold(
      body: StackNavBar(
        body: Scaffold(
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScn(),
              SearchScn(),
              LibraryScn(),
              CartScn(),
            ],
          ),
        ),
        items: _getNavBarItems(),
        onChange: (index) {
          pageController.jumpToPage(index);
        },
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
