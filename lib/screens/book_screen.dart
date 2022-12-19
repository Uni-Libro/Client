import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../services/local_api.dart';
import '../utils/extension.dart';
import '../models/book_model.dart';
import '../services/localization/strs.dart';
import '../widgets/my_app_bar/book_app_bar.dart';
import 'author_screen.dart';

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

    final isMyBook =
        LocalAPI().currentUsersBooks.any((mb) => mb.id == delegate.id);
    final rTag = tag.obs;
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
          tag: rTag,
          delegate: delegate,
          isShowAppBarTitle: isShowAppBarTitle,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isShowFAB.value && !isMyBook
          ? FloatingActionButton.extended(
              label: Text(
                  "${Strs.addToCart.tr} | ${delegate.price.toString().trNums().seRagham()} ${Strs.currency.tr}"),
              onPressed: () =>
                  LocalAPI().addToCartBookScnBtnOnPressed(rTag, delegate),
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
  final Rx<Object> tag;
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
            (i) {
              final aTag = UniqueKey();
              return CupertinoButton(
                onPressed: () {
                  Get.to(
                    () => AuthorScn(
                        delegate: delegate.authorModels![i], tag: aTag),
                    duration: const Duration(milliseconds: 800),
                  );
                },
                padding: EdgeInsets.zero,
                child: Chip(
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
              );
            },
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
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCategoryPart() {
    return Center(
      child: Text(
        delegate.categoryModels?.map((e) => e.name).join(' | ') ?? "",
        style: Get.textTheme.subtitle2?.copyWith(
          color: Get.textTheme.headline1?.color,
        ),
      ),
    );
  }
}
