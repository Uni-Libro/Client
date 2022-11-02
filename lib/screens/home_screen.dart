import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../assets/assets.gen.dart';
import '../services/localization/strs.dart';
import '../utils/constants.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';
import '../widgets/home_bottom_sheet.dart/home_bottom_sheet.dart';
import '../widgets/my_app_bar/my_app_bar.dart';
import '../widgets/my_books_widget/my_books_content.dart';
import 'setting_screen.dart';

class HomeScn extends StatelessWidget {
  const HomeScn({super.key});

  static const double globalPadding = 20;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: MyAppBar(
        toolbarHeight: kToolbarHeight + 20,
        titleSpacing: 0,
        title: AnimationBuilder(
          6,
          -50,
          0,
          _buildAppBarTitle(),
        ),
        actions: [
          AnimationBuilder(
            6,
            0,
            -50,
            _buildSettingBtn(context),
          ),
          const SizedBox(width: 10),
          AnimationBuilder(
            6,
            50,
            0,
            _buildAvatar(),
          ),
          const SizedBox(width: globalPadding),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(
            Strs.home.tr,
            style: Get.textTheme.headline5,
          ),
        ),
      ),
      bottomSheet: AnimationBuilder(
        7,
        0,
        100,
        HomeBottomSheet(
          expandedChild: MyBooksContent(
            books: _getMyBooks(),
            scrollDirection: Axis.vertical,
          ),
          collapsedChild: Text(
            Strs.myBooks.tr,
            style: Get.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: MyBooksContent(
            books: _getMyBooks(),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    final dateTime = DateTime.now();
    final isShamsiDate = Get.locale! == const Locale('fa', 'IR');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: globalPadding),
        Text(
          isShamsiDate
              ? dateTime.toPersianDate().split('/')[2]
              : dateTime.day.toString(),
          style: Get.textTheme.headline2?.copyWith(
            color: Get.theme.colorScheme.onBackground,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '${isShamsiDate ? persianWeekday[dateTime.weekday - 1] : englishWeekday[dateTime.weekday - 1]}\n'
          '${isShamsiDate ? dateTime.toPersianDateStr(strMonth: true, seprator: '.').split('.')[1] : englishMonth[dateTime.month - 1]} '
          '${isShamsiDate ? dateTime.toPersianDate().split('/')[0] : dateTime.year.toString()}',
          style: Get.textTheme.bodyText1?.copyWith(
            height: isShamsiDate ? 1.5 : 1,
            color: Get.textTheme.headline2?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingBtn(BuildContext context) {
    return CupertinoButton(
      child: Assets.icons.category2Bulk.svg(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        Get.to(
          () => const SettingScn(),
          transition: Transition.cupertino,
        );
      },
    );
  }

  Widget _buildAvatar() {
    return const AvatarWidget(
      url:
          'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
    );
  }

  List<BookItemDelegate> _getMyBooks() {
    return [
      BookItemDelegate(
        '‌Book 1',
        'Author 1',
        'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
        'This is th description of book 1 ' * 5,
      ),
      BookItemDelegate(
        '‌Book 2',
        'Author 2',
        'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
        'This is th description of book 2 ' * 5,
      ),
      BookItemDelegate(
        '‌Book 3',
        'Author 3',
        'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
        'This is th description of book 3 ' * 5,
      ),
      BookItemDelegate(
        '‌Book 4',
        'Author 4',
        'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg',
        'This is th description of book 4 ' * 5,
      ),
    ];
  }
}
