import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../services/localization/strs.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';
import '../widgets/my_app_bar/my_app_bar.dart';

class HomeScn extends StatelessWidget {
  const HomeScn({super.key});

  static const double globalPadding = 20;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: MyAppBar(
        toolbarHeight: kToolbarHeight + 20,
        titleSpacing: 0,
        title: _buildAppBarTitle(),
        actions: [
          _buildSettingBtn(context),
          const SizedBox(width: 10),
          _buildAvatar(),
          const SizedBox(width: globalPadding),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.1),
        child: Center(
          child: Text(
            Strs.home.tr,
            style: Get.textTheme.headline5,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: globalPadding),
        Text(
          '30',
          style: Get.textTheme.headline2?.copyWith(
            color: Get.theme.colorScheme.onBackground,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'Mon\nMarch 2020',
          style: Get.textTheme.bodyText1?.copyWith(
            height: 1,
            fontWeight: FontWeight.w500,
            color: Get.textTheme.headline2?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingBtn(BuildContext context) {
    return CupertinoButton(
      child: Assets.icons.category2Bulk.svg(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {},
    );
  }

  Widget _buildAvatar() {
    return const AvatarWidget(
      url:
          'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
    );
  }
}
