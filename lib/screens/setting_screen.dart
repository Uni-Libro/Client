import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/extension.dart';
import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';
import '../widgets/setting_widgets/animation_option.dart';
import '../widgets/setting_widgets/language_option.dart';
import '../widgets/setting_widgets/password_option.dart';
import '../widgets/setting_widgets/sign_out_option.dart';
import '../widgets/setting_widgets/theme_option.dart';

class SettingScn extends StatelessWidget {
  const SettingScn({super.key});

  static const double padding = 20;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            ProfileAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: AccountOptions(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: SettingsOptions(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: SignOutOption(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: AppLogoWidget(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }
}

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.dakkeLogo.image(
          color: Theme.of(context).colorScheme.onBackground,
          width: 100,
          height: 100,
        ),
        Text(Strs.fullAppName.tr),
        Text(Strs.version.tr),
      ],
    );
  }
}

class AccountOptions extends StatelessWidget {
  const AccountOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    Strs.accountInfo.tr,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const PasswordOption(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsOptions extends StatelessWidget {
  const SettingsOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    Strs.setting.tr,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const AnimationSettingOption(),
              const Divider(indent: 30, endIndent: 30, thickness: 1),
              const ThemeSettingOption(),
              const Divider(indent: 30, endIndent: 30, thickness: 1),
              const LanguageSettingOption(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leading: CupertinoButton(
        onPressed: () => Get.back(),
        child: RotatedBox(
          quarterTurns:
              LocalizationService.textDirection == TextDirection.rtl ? 2 : 0,
          child: Assets.icons.arrowLeft1TwoTone
              .svg(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Hero(
                tag: 'profileImg',
                child: AvatarWidget(
                  size: 120,
                  //   url: MockData().getAvatar(),
                ),
              ),
              const SizedBox(height: 25),
              Obx(
                () => Text(
                  '${LocalAPI().currentUserProfile.phone?.trNums()}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
