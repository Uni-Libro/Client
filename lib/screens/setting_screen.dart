import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../services/theme/theme_service.dart';
import '../utils/mock_data.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';

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

class SignOutOption extends StatelessWidget {
  const SignOutOption({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(Strs.signOut.tr),
            ),
          ),
        ),
      ),
      onPressed: () {},
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
              const EmailOption(),
              const Divider(indent: 30, endIndent: 30, thickness: 1),
              const UsernameOption(),
              const Divider(indent: 30, endIndent: 30, thickness: 1),
              const PasswordOption(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class PasswordOption extends StatelessWidget {
  const PasswordOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.lockBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Text(Strs.editPassword.tr),
      //   onTap: () {},
      trailing: Assets.icons.arrowLeft1TwoTone.svg(
        color: Theme.of(context).colorScheme.onSurface,
        width: 16,
        height: 16,
      ),
    );
  }
}

class UsernameOption extends StatelessWidget {
  const UsernameOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.profileBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Strs.username.tr),
          const SizedBox(width: 25),
          Expanded(
            child: Align(
              alignment: LocalizationService.textDirection == TextDirection.ltr
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                "Iman Ghasemi Arani",
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      //   onTap: () {},
      trailing: Assets.icons.edit2Bulk.svg(
        color: Theme.of(context).colorScheme.onSurface,
        width: 16,
        height: 16,
      ),
    );
  }
}

class EmailOption extends StatelessWidget {
  const EmailOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.smsBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Strs.email.tr),
          const SizedBox(width: 25),
          Expanded(
            child: Align(
              alignment: LocalizationService.textDirection == TextDirection.ltr
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                "iman.ghasemi.arani@gmail.com",
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      //   onTap: () {},
      trailing: Assets.icons.edit2Bulk.svg(
        color: Theme.of(context).colorScheme.onSurface,
        width: 16,
        height: 16,
      ),
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
              Hero(
                  tag: 'profileImg',
                  child: AvatarWidget(size: 120, url: MockData().getAvatar())),
              const SizedBox(height: 25),
              const UserFullNameWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserFullNameWidget extends StatelessWidget {
  const UserFullNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Iman Ghasemi Arani",
      style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}

class AnimationSettingOption extends StatelessWidget {
  const AnimationSettingOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isShowAnimation = LocalAPI().isShowAnimation.obs;
    return ListTile(
      leading: Assets.icons.speedometerBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Text(Strs.animation.tr),
      trailing: Transform.scale(
        scale: 0.8,
        child: Obx(
          () => CupertinoSwitch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: isShowAnimation.value,
            onChanged: (value) {
              LocalAPI().isShowAnimation = isShowAnimation.value = value;
            },
          ),
        ),
      ),
    );
  }
}

class LanguageSettingOption extends StatelessWidget {
  const LanguageSettingOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        textColor: Theme.of(context).colorScheme.onSurface,
        iconColor: Theme.of(context).colorScheme.onSurface,
        leading: Assets.icons.languageSquareBulk
            .svg(color: Theme.of(context).colorScheme.onSurface),
        subtitle: Text(LocalizationService
            .displayLangs[LocalizationService.locales.indexOf(Get.locale!)]),
        title: Text(Strs.language.tr),
        children: List.generate(
          LocalizationService.langs.length,
          (index) => ListTile(
            title: Text(LocalizationService.displayLangs[index].tr),
            leading: Radio<int>(
              activeColor: Theme.of(context).colorScheme.primary,
              value: index,
              groupValue: LocalizationService.locales.indexOf(Get.locale!),
              onChanged: (int? value) {
                LocalizationService.changeLocale(
                    LocalizationService.langs[value ?? 0]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeSettingOption extends StatelessWidget {
  const ThemeSettingOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find();
    final currentTheme = themeService.mode.obs;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        textColor: Theme.of(context).colorScheme.onSurface,
        iconColor: Theme.of(context).colorScheme.onSurface,
        leading: Assets.icons.lampBulk
            .svg(color: Theme.of(context).colorScheme.onSurface),
        subtitle: Obx(() => Text(currentTheme.value == ThemeMode.system
            ? Strs.deviceDefault.tr
            : currentTheme.value.name.capitalize!.tr)),
        title: Text(Strs.theme.tr),
        children: List.generate(
          ThemeMode.values.length,
          (index) => ListTile(
            title: Text(ThemeMode.values[index] == ThemeMode.system
                ? Strs.deviceDefault.tr
                : ThemeMode.values[index].name.capitalize!.tr),
            leading: Obx(
              () => Radio<ThemeMode>(
                activeColor: Theme.of(context).colorScheme.primary,
                value: ThemeMode.values[index],
                groupValue: currentTheme.value,
                onChanged: (value) {
                  currentTheme.value =
                      themeService.mode = value ?? ThemeMode.system;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
