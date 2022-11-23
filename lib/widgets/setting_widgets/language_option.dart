import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';

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
