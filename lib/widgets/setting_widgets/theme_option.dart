import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/localization/strs.dart';
import '../../services/theme/theme_service.dart';

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