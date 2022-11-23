import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/localization/strs.dart';

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