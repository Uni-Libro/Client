import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../animations/animation_widget.dart';

typedef OnChange = void Function(int index);

class StackNavBar extends StatelessWidget {
  const StackNavBar({
    Key? key,
    required this.body,
    required this.items,
    this.onChange,
    this.initItemIndex = 0,
  }) : super(key: key);

  final Widget body;
  final List<StackNavBarItem> items;
  final OnChange? onChange;
  final int initItemIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: [
          Expanded(
            child: ClipSmoothRect(
              radius: const SmoothBorderRadius.vertical(
                  bottom: SmoothRadius(
                cornerRadius: 60,
                cornerSmoothing: 1,
              )),
              child: body,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: NavBar(
                items: items, initItemIndex: initItemIndex, onChange: onChange),
          ),
        ],
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({
    Key? key,
    required this.items,
    required this.initItemIndex,
    required this.onChange,
  }) : super(key: key);

  final List<StackNavBarItem> items;
  final int initItemIndex;
  final OnChange? onChange;

  @override
  Widget build(BuildContext context) {
    final itemController = List.generate(
      items.length,
      (index) => (index == initItemIndex).obs,
    );
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          items.length,
          (i) => Obx(
            () => CupertinoButton(
              minSize: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onPressed: itemController[i].value
                  ? null
                  : () {
                      onChange?.call(i);
                      itemController
                          .forEach((element) => element.value = false);
                      itemController[i].value = true;
                    },
              child: AnimationBuilder(
                i + 2,
                0,
                50,
                StackNavBarItem(
                  icon: items[i].icon,
                  selectedIcon: items[i].selectedIcon,
                  title: items[i].title,
                  isSelected: itemController[i].value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StackNavBarItem extends StatelessWidget {
  const StackNavBarItem({
    super.key,
    this.selectedIcon,
    required this.icon,
    this.title,
    this.isSelected = false,
  });

  final Widget? selectedIcon;
  final Widget icon;
  final String? title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isSelected ? selectedIcon ?? icon : icon,
        if (title != null) const SizedBox(height: 2),
        if (title != null)
          Text(
            title!,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.5),
                ),
          ),
      ],
    );
  }
}
