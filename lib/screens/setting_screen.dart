import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../services/theme/theme_service.dart';

class SettingScn extends StatelessWidget {
  const SettingScn({super.key});

  static const double padding = 20;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            leading: CupertinoButton(
              onPressed: () => Get.back(),
              child: RotatedBox(
                quarterTurns:
                    LocalizationService.textDirection == TextDirection.rtl
                        ? 2
                        : 0,
                child: Assets.icons.arrowLeft1TwoTone
                    .svg(color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(Strs.setting.tr),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    AnimationSettingOption(),
                    Divider(indent: 30, endIndent: 30, thickness: 1),
                    ThemeSettingOption(),
                    Divider(indent: 30, endIndent: 30, thickness: 1),
                    LanguageSettingOption(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
