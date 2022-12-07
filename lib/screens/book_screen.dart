import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../utils/extension.dart';
import '../assets/assets.gen.dart';
import '../models/book_model.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../widgets/my_app_bar/my_app_bar.dart';

class BookScn extends HookWidget {
  const BookScn({
    super.key,
    required this.delegate,
    required this.tag,
  });

  static const double tileHeight = 250;

  final BookModel delegate;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final isShowFAB = useState(false);
    final isShowAppBarTitle = false.obs;
    ScrollController sController = useScrollController();
    sController.addListener(() {
      if (sController.offset > 100) {
        isShowFAB.value = true;
      } else {
        isShowFAB.value = false;
      }

      if (sController.offset > tileHeight + 150) {
        isShowAppBarTitle.value = true;
      } else {
        isShowAppBarTitle.value = false;
      }
    });
    return Scaffold(
      body: SafeArea(
        child: ScrollableBody(
          sController: sController,
          tileHeight: tileHeight,
          tag: tag,
          delegate: delegate,
          isShowAppBarTitle: isShowAppBarTitle,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isShowFAB.value
          ? FloatingActionButton.extended(
              label: Text(
                  "${Strs.addToCart.tr} | ${delegate.price.toString().trNums()} ${Strs.currency.tr}"),
              onPressed: () {},
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              )),
              backgroundColor: Get.theme.colorScheme.primary,
            )
          : null,
    );
  }
}

class ScrollableBody extends StatelessWidget {
  const ScrollableBody({
    Key? key,
    required this.sController,
    required this.tileHeight,
    required this.tag,
    required this.delegate,
    required this.isShowAppBarTitle,
  }) : super(key: key);

  final ScrollController sController;
  final double tileHeight;
  final Object tag;
  final BookModel delegate;
  final RxBool isShowAppBarTitle;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: sController,
      slivers: [
        BookAppBar(
          tileHeight: tileHeight,
          tag: tag,
          delegate: delegate,
          isShowAppBarTitle: isShowAppBarTitle,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(bottom: 50, right: 20, left: 20),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 35),
                    child: Column(
                      children: [
                        _buildBookNamePart(),
                        const SizedBox(height: 10),
                        _buildAuthorsPart(),
                        const SizedBox(height: 10),
                        _buildCategoryPart(),
                        const SizedBox(height: 20),
                        _buildDescPart(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescPart() {
    return Text(
      delegate.description!,
      style: Get.textTheme.bodyText1,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildAuthorsPart() {
    return Center(
      child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            delegate.authorModels?.length ?? 0,
            (i) => Chip(
              backgroundColor:
                  Get.theme.colorScheme.onSurface.withOpacity(0.05),
              label: Text(delegate.authorModels![i].name!),
              avatar: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox.expand(
                  child: CachedNetworkImage(
                    imageUrl: delegate.authorModels![i].imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildBookNamePart() {
    return Center(
      child: Text(
        delegate.name!,
        style: Get.textTheme.headline6?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryPart() {
    return Center(
      child: Text(
        delegate.categoryModels?.map((e) => e.name).join(', ') ?? "",
        style: Get.textTheme.subtitle2?.copyWith(
          color: Get.textTheme.headline1?.color,
        ),
      ),
    );
  }
}

class BookAppBar extends StatelessWidget {
  const BookAppBar({
    Key? key,
    required this.tileHeight,
    required this.tag,
    required this.delegate,
    required this.isShowAppBarTitle,
  }) : super(key: key);

  final double tileHeight;
  final Object tag;
  final BookModel delegate;
  final RxBool isShowAppBarTitle;

  @override
  Widget build(BuildContext context) {
    return MySliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leadingWidth: 24 + 40,
      leading: CupertinoButton(
        onPressed: () => Get.back(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: RotatedBox(
          quarterTurns:
              LocalizationService.textDirection == TextDirection.rtl ? 2 : 0,
          child: Assets.icons.arrowLeft1TwoTone
              .svg(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      actions: [
        StatefulBuilder(builder: (context, setState) {
          return CupertinoButton(
            onPressed: () {
              setState(() => delegate.isMark = !delegate.isMark);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: delegate.isMark
                ? Assets.icons.bookmarkBulk
                    .svg(color: Theme.of(Get.context!).colorScheme.onBackground)
                : Assets.icons.bookmarkTwoTone.svg(
                    color: Theme.of(Get.context!).colorScheme.onBackground),
          );
        }),
      ],
      centerTitle: true,
      title: Obx(() => isShowAppBarTitle.value
          ? Text(
              delegate.name!,
              style: Get.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          : const SizedBox.shrink()),
      expandedHeight: tileHeight + 150,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: tileHeight,
                  child: Hero(
                    tag: tag,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: ClipSmoothRect(
                        radius: SmoothBorderRadius(
                          cornerRadius: 20,
                          cornerSmoothing: 1,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1 / 1.6,
                          child: CachedNetworkImage(
                            imageUrl: delegate.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Card(
                              margin: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildBuyBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 1,
          ),
          child: CupertinoButton.filled(
            child: Text(
              "${Strs.addToCart.tr} | ${delegate.price.toString().trNums()} ${Strs.currency.tr}",
              style:
                  CupertinoTheme.of(Get.context!).textTheme.textStyle.copyWith(
                        fontFamily: Get.textTheme.button?.fontFamily,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
