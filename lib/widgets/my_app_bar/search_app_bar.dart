import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../services/localization/strs.dart';
import 'my_app_bar.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key, this.onSubmitted});

  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return MySliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floating: true,
      snap: true,
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: Strs.searchBox.tr,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Assets.icons.searchNormalBulk
                .svg(color: Get.theme.colorScheme.onBackground),
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
