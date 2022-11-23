import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';

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