import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../services/local_api.dart';
import '../../utils/extension.dart';
import '../../assets/assets.gen.dart';
import '../../models/book_model.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';
import '../btn_widgets/bookmark_btn.dart';
import 'my_app_bar.dart';

class BookAppBar extends StatelessWidget {
  const BookAppBar({
    Key? key,
    required this.tileHeight,
    required this.tag,
    required this.delegate,
    required this.isShowAppBarTitle,
  }) : super(key: key);

  final double tileHeight;
  final Rx<Object> tag;
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
        BookmarkBtn(delegate: delegate),
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
                  child: Obx(
                    () => Hero(
                      tag: tag.value,
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
                ),
                _buildBuyBtn(tag),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyBtn(Rx<Object> rTag) {
    final isProcess = false.obs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 1,
          ),
          child: CupertinoButton.filled(
            onPressed: () async {
              if (isProcess.value) return;
              isProcess.value = true;
              await LocalAPI().addToCartBookScnBtnOnPressed(rTag, delegate);
              isProcess.value = false;
            },
            child: Obx(
              () => !isProcess.value
                  ? Text(
                      "${Strs.addToCart.tr} | ${delegate.price.toString().trNums().seRagham()} ${Strs.currency.tr}",
                      style: CupertinoTheme.of(Get.context!)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontFamily: Get.textTheme.button?.fontFamily,
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                    )
                  : Center(
                      child: FittedBox(
                        child: CircularProgressIndicator(
                          color: Get.theme.colorScheme.onPrimary,
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
