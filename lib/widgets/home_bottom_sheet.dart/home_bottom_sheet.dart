import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
    required this.child,
    required this.expandedChild,
    required this.closedChild,
  });

  static const initValue = 0.4;
  final Widget child;
  final Widget expandedChild;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    bool isAnimating = false;
    final sheetStatus = _HomeBottomSheetStatus.normal.obs;
    final animationValue = initValue.obs;
    return LayoutBuilder(
      builder: (context, constrains) => Obx(
        () => AnimatedContainer(
          duration: isAnimating
              ? const Duration(milliseconds: 200)
              : const Duration(milliseconds: 100),
          curve: Curves.ease,
          onEnd: () => isAnimating = false,
          clipBehavior: Clip.antiAlias,
          height: constrains.maxHeight * animationValue.value,
          decoration: _getDecoration(context, animationValue),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              animationValue.value -=
                  details.primaryDelta! / constrains.maxHeight;
              if (animationValue.value < 0.15) {
                animationValue.value = 0.15;
              }
            },
            onVerticalDragEnd: (() {
              switch (sheetStatus.value) {
                case _HomeBottomSheetStatus.normal:
                  return (details) {
                    if (animationValue.value <= initValue - 0.1) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.closed;
                      animationValue.value = 0.15;
                    } else if (animationValue.value <= initValue + 0.1) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.normal;
                      animationValue.value = initValue;
                    } else {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.expanded;
                      animationValue.value = 1;
                    }
                  };
                case _HomeBottomSheetStatus.expanded:
                  return (details) {
                    if (animationValue.value >= 0.9) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.expanded;
                      animationValue.value = 1;
                    } else if (animationValue.value > initValue - 0.1) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.normal;
                      animationValue.value = initValue;
                    } else {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.closed;
                      animationValue.value = 0.15;
                    }
                  };
                case _HomeBottomSheetStatus.closed:
                  return (details) {
                    if (animationValue.value <= 0.2) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.closed;
                      animationValue.value = 0.15;
                    } else if (animationValue.value <= initValue + 0.1) {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.normal;
                      animationValue.value = initValue;
                    } else {
                      isAnimating = true;
                      sheetStatus.value = _HomeBottomSheetStatus.expanded;
                      animationValue.value = 1;
                    }
                  };
              }
            }()),
            onTap: sheetStatus.value == _HomeBottomSheetStatus.closed
                ? () {
                    isAnimating = true;
                    sheetStatus.value = _HomeBottomSheetStatus.normal;
                    animationValue.value = initValue;
                  }
                : null,
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  child: const SizedBox.expand(),
                ),
                _buildChild(sheetStatus),
                const _TopIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Rx<_HomeBottomSheetStatus> sheetStatus) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (() {
          switch (sheetStatus.value) {
            case _HomeBottomSheetStatus.normal:
              return child;
            case _HomeBottomSheetStatus.expanded:
              return expandedChild;
            case _HomeBottomSheetStatus.closed:
              return closedChild;
          }
        }()),
      ),
    );
  }

  ShapeDecoration _getDecoration(
      BuildContext context, RxDouble animationValue) {
    return ShapeDecoration(
      color: Theme.of(context).colorScheme.surface,
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 10,
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
                (60 * (1 - animationValue.value + initValue)).clamp(0, 60),
            cornerSmoothing: 1,
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

enum _HomeBottomSheetStatus { normal, expanded, closed }
