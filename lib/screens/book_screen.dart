import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/book_model.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../widgets/scroll_behavior/scroll_behavior.dart';

class BookScn extends StatelessWidget {
  const BookScn({
    super.key,
    required this.delegate,
    required this.tag,
  });

  final BookModel delegate;
  final Object tag;

  static const double tileHeight = 350;
  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoIndicatorScrollBehavior(),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              BookAppBar(tileHeight: tileHeight, tag: tag, delegate: delegate),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BookBody(delegate: delegate),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildBuyBtn(),
    );
  }

  Widget _buildBuyBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: SizedBox(
        width: double.infinity,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 13,
            cornerSmoothing: 1,
          ),
          child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 64.0,
            ),
            child: Text(
              Strs.addToCart.tr,
              style:
                  CupertinoTheme.of(Get.context!).textTheme.textStyle.copyWith(
                        fontFamily: Get.textTheme.button?.fontFamily,
                        color: Get.theme.colorScheme.onPrimary,
                        fontSize: 20,
                      ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class BookBody extends StatelessWidget {
  const BookBody({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final BookModel delegate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  delegate.name!,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context).textTheme.headline6?.color,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  delegate.authorName!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).textTheme.headline1?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  delegate.description!,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: 18,
                      ),
                  // textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BookAppBar extends StatelessWidget {
  const BookAppBar({
    Key? key,
    required this.tileHeight,
    required this.tag,
    required this.delegate,
  }) : super(key: key);

  final double tileHeight;
  final Object tag;
  final BookModel delegate;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
        CupertinoButton(
          onPressed: () {},
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Assets.icons.more2TwoTone
              .svg(color: Theme.of(Get.context!).colorScheme.onBackground),
        ),
      ],
      //   centerTitle: true,
      //   title: Text(
      //     Strs.detailBook.tr,
      //     style: Get.textTheme.headline6,
      //     overflow: TextOverflow.ellipsis,
      //     textAlign: TextAlign.center,
      //   ),
      expandedHeight: tileHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Hero(
              tag: tag,
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
      ),
    );
  }
}
