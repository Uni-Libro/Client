import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/local_api.dart';
import '../../services/localization/strs.dart';

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
