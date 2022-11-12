import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../assets/assets.gen.dart';
import '../services/localization/strs.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/authors_view.dart/authors_view.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';
import '../widgets/books_view.dart/books_view.dart';
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
          1,
          -50,
          0,
          _buildAppBarTitle(),
        ),
        actions: [
          AnimationBuilder(
            1,
            0,
            -50,
            _buildSettingBtn(context),
          ),
          const SizedBox(width: 10),
          AnimationBuilder(
            1,
            50,
            0,
            _buildAvatar(),
          ),
          const SizedBox(width: globalPadding),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnimationLimiter(
          child: Column(
            children: [
              _buildRecommendedBooksView(2),
              _buildAuthorsView(3),
              _buildRecommendedBooksView(4),
              _buildRecommendedBooksView(5),
              _buildRecommendedBooksView(6),
              _buildRecommendedBooksView(7),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      bottomSheet: AnimationBuilder(
        8,
        0,
        100,
        HomeBottomSheet(
          expandedChild: MyBooksContent(
            key: UniqueKey(),
            books: MockData().getMyBooks(),
            scrollDirection: Axis.vertical,
          ),
          closedChild: Text(
            Strs.myBooks.tr,
            style: Get.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: MyBooksContent(
            key: UniqueKey(),
            books: MockData().getMyBooks(),
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
            height: isShamsiDate ? 1 : 1,
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
    return AvatarWidget(
      url: MockData().getAvatar(),
    );
  }

  Widget _buildRecommendedBooksView(
    int position,
  ) {
    return BooksView(
      position: position,
      title: Strs.recommended.tr,
      delegates: MockData().getBooks(),
    );
  }

  Widget _buildAuthorsView(int position) {
    return AuthorsView(
      position: position,
      delegates: MockData().getAuthors(),
    );
  }
}
