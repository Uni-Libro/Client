import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../models/book_model.dart';
import '../utils/extension.dart';
import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/my_app_bar/my_app_bar.dart';

final aListKey = GlobalKey<AnimatedListState>();

class CartScn extends StatelessWidget {
  const CartScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: MyAppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(Strs.cart.tr),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => LocalAPI().cart.isEmpty
                  ? Center(
                      child: Text(Strs.cartIsEmpty.tr,
                          style: Get.textTheme.bodyText1),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimationLimiter(
                child: AnimatedList(
                  key: aListKey,
                  clipBehavior: Clip.none,
                  initialItemCount: LocalAPI().cart.length,
                  itemBuilder: (context, i, animation) => AnimationBuilder(
                      i, -50, 0, CartItem(index: i, model: LocalAPI().cart[i])),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayBtn(),
    );
  }

  Widget _buildPayBtn() {
    return SizedBox(
      width: double.infinity,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        child: CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 64,
          ),
          child: Obx(
            () => Text(
              "${Strs.pay.tr} | ${LocalAPI().cart.fold(0, (pV, e) => pV + e.price!).toString().trNums()} ${Strs.currency.tr}",
              style:
                  CupertinoTheme.of(Get.context!).textTheme.textStyle.copyWith(
                        fontFamily: Get.textTheme.button?.fontFamily,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.index,
    required this.model,
  });

  final int index;
  final BookModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: 170,
              child: ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: 20,
                  cornerSmoothing: 1,
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1.6,
                  child: CachedNetworkImage(
                    imageUrl: model.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Card(
                      margin: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      model.authorModels?.map((e) => e.name).join(' | ') ?? "",
                      style: Get.textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const Spacer(),
                    Assets.icons.bookBulk.svg(
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Assets.icons.trashBulk.svg(color: Colors.red),
                    onPressed: () {
                      LocalAPI().cart.removeAt(index);
                      aListKey.currentState?.removeItem(
                        index,
                        (context, animation) => SizeTransition(
                          sizeFactor: animation,
                          child: CartItem(
                            index: index,
                            model: model,
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString().trNums(),
                        style: Get.textTheme.headline6,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        Strs.currency.tr,
                        style: Get.textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
