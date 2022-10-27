import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LoadingAnimationWidget.hexagonDots(
          color: Theme.of(context).colorScheme.primary,
          size: size,
        ),
      ),
    );
  }
}
