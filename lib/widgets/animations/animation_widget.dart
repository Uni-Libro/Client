import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../services/local_api.dart';
import '../../services/localization/localization_service.dart';

class AnimationBuilder extends StatelessWidget {
  const AnimationBuilder(
    this.position,
    this.ho,
    this.vo,
    this.child, {
    super.key,
  });
  final int position;
  final Widget child;
  final double ho;
  final double vo;

  @override
  Widget build(BuildContext context) {
    if (LocalAPI().isShowAnimation) {
      return AnimationConfiguration.staggeredList(
        duration: const Duration(milliseconds: 500),
        position: position,
        child: SlideAnimation(
          horizontalOffset: ho *
              (LocalizationService.textDirection == TextDirection.ltr ? 1 : -1),
          verticalOffset: vo,
          child: FadeInAnimation(
            child: child,
          ),
        ),
      );
    } else {
      return child;
    }
  }
}
