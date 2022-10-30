import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../services/localization/localization_service.dart';

class HomeBottomSheet extends HookWidget {
  const HomeBottomSheet({
    super.key,
    required this.child,
    required this.expandedChild,
    required this.collapsedChild,
  });

  static const initValue = 0.4;
  final Widget child;
  final Widget expandedChild;
  final Widget collapsedChild;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      initialValue: initValue,
    );
    bool isExpanded = false;
    bool isCollapsed = false;
    return LayoutBuilder(
      builder: (context, constrains) {
        return StatefulBuilder(builder: (context, setState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: animationController.value * constrains.maxHeight,
            width: constrains.maxWidth,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface,
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.vertical(
                  bottom: const SmoothRadius(
                    cornerRadius: 60,
                    cornerSmoothing: 1,
                  ),
                  top: SmoothRadius(
                    cornerRadius:
                        (60 * (1 - animationController.value + initValue))
                            .clamp(0, 60),
                    cornerSmoothing: 1,
                  ),
                ),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: isCollapsed
                        ? collapsedChild
                        : isExpanded
                            ? expandedChild
                            : child,
                  ),
                ),
                if (!isCollapsed) const _TopIndicator(),
                if (!isCollapsed)
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onVerticalDragUpdate: isCollapsed
                          ? null
                          : (details) {
                              setState(() {
                                animationController.value -=
                                    details.primaryDelta! /
                                        constrains.maxHeight;
                                if (animationController.value < initValue) {
                                  animationController.value = initValue;
                                }
                              });
                            },
                      onVerticalDragEnd: isCollapsed
                          ? null
                          : isExpanded
                              ? (details) => setState(() {
                                    if (animationController.value > 0.9) {
                                      animationController.value = 1;
                                      isExpanded = true;
                                      animationController.forward();
                                    } else {
                                      animationController.value = initValue;
                                      isExpanded = false;
                                      animationController.reverse();
                                    }
                                  })
                              : (details) => setState(() {
                                    if (animationController.value <
                                        initValue + 0.1) {
                                      animationController.value = initValue;
                                      isExpanded = false;
                                      animationController.reverse();
                                    } else {
                                      animationController.value = 1;
                                      isExpanded = true;
                                      animationController.forward();
                                    }
                                  }),
                      child: Container(
                        width: constrains.maxWidth,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                _CollapseToggle(
                  turns: isCollapsed ? 0 : 0.5,
                  onToggle: () {
                    setState(() {
                      if (isCollapsed) {
                        animationController.value = initValue;
                        isExpanded = false;
                        isCollapsed = false;
                        animationController.reverse();
                      } else {
                        animationController.value = 0.15;
                        isExpanded = false;
                        isCollapsed = true;
                        animationController.forward();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class _CollapseToggle extends StatelessWidget {
  const _CollapseToggle({
    Key? key,
    this.onToggle,
    required this.turns,
  }) : super(key: key);

  final void Function()? onToggle;
  final double turns;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: LocalizationService.textDirection == TextDirection.ltr
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: CupertinoButton(
          onPressed: onToggle,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: turns,
            child: Icon(
              CupertinoIcons.chevron_up,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopIndicator extends StatelessWidget {
  const _TopIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
