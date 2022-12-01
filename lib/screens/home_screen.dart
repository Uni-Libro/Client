import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

// import '../assets/assets.gen.dart';
import '../assets/assets.gen.dart';
import '../services/init_app_services.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import '../utils/constants.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/authors_view.dart/authors_view.dart';
import '../widgets/avatar_widget.dart/avatar_widget.dart';
import '../widgets/books_view.dart/books_view.dart';
import '../widgets/home_bottom_sheet.dart/home_bottom_sheet.dart';
import '../widgets/my_app_bar/my_app_bar.dart';
import '../widgets/my_books_widget/my_books_content.dart';
import '../widgets/scroll_behavior/scroll_behavior.dart';
import 'setting_screen.dart';

class HomeScn extends StatelessWidget {
  const HomeScn({super.key});

  static const double globalPadding = 20;
  static const double offsetToArmed = 220;

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
          //   AnimationBuilder(
          //     1,
          //     0,
          //     -50,
          //     _buildSettingBtn(context),
          //   ),
          //   const SizedBox(width: 10),
          AnimationBuilder(
            1,
            50,
            0,
            _buildAvatar(),
          ),
          const SizedBox(width: globalPadding),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: loadHomeScreenDataFromServer,
        offsetToArmed: offsetToArmed,
        builder: (context, child, controller) => AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (context, child) {
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: offsetToArmed * controller.value,
                  child: Assets.animations.pullToRefreshRasterGraphics.rive(
                    fit: BoxFit.cover,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, offsetToArmed * controller.value),
                  child: child,
                ),
              ],
            );
          },
        ),
        child: ScrollConfiguration(
          behavior: NoIndicatorScrollBehavior(),
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: AnimationLimiter(
              child: Column(
                children: [
                  _buildRecommendedBooksView(2),
                  _buildSpecialsBooksView(3),
                  _buildAuthorsView(4),
                  ..._buildCategoriesBooksView(5),
                  const SizedBox(height: 150),
                ],
              ),
            ),
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
            books: LocalAPI().currentUsersBooks,
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
            books: LocalAPI().currentUsersBooks,
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

//   Widget _buildSettingBtn(BuildContext context) {
//     return CupertinoButton(
//       child: Assets.icons.category2Bulk.svg(
//         color: Theme.of(context).colorScheme.onBackground,
//       ),
//       onPressed: () {
//         Get.to(
//           () => const SettingScn(),
//           transition: Transition.cupertino,
//         );
//       },
//     );
//   }

  Widget _buildAvatar() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Hero(
        tag: 'profileImg',
        child: AvatarWidget(
            //   url: MockData().getAvatar(),
            ),
      ),
      onPressed: () {
        Get.to(const SettingScn());
      },
    );
  }

  Widget _buildRecommendedBooksView(
    int position,
  ) {
    return Obx(
      () => BooksView(
        position: position,
        title: LocalAPI().categories[0].name!.tr,
        delegates: LocalAPI().categories[0].books!,
      ),
    );
  }

  Widget _buildSpecialsBooksView(
    int position,
  ) {
    return Obx(
      () => BooksView(
        position: position,
        title: LocalAPI().categories[1].name!.tr,
        delegates: LocalAPI().categories[1].books!,
      ),
    );
  }

  List<Widget> _buildCategoriesBooksView(
    int position,
  ) {
    return List.generate(
      LocalAPI().categories.length - 2,
      (i) => Obx(
        () => BooksView(
          position: i + position,
          title: LocalAPI().categories[i + 2].name!,
          delegates: LocalAPI().categories[i + 2].books!,
        ),
      ),
    );
  }

  Widget _buildAuthorsView(int position) {
    return AuthorsView(
      position: position,
      delegates: LocalAPI().authors,
    );
  }
}
