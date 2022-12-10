import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../models/book_model.dart';
import '../utils/extension.dart';
import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/btn_widgets/remove_cart_item_btn.dart';
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
              () => LocalAPI().cartItems.isEmpty
                  ? Center(
                      child: SizedBox.square(
                        dimension: Get.width,
                        child: Stack(
                          children: [
                            Assets.animations.impatientPlaceholder
                                .rive(fit: BoxFit.cover),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.width * 0.25),
                                child: Text(Strs.cartIsEmpty.tr,
                                    style: Get.textTheme.bodyText1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimationLimiter(
                child: AnimatedList(
                  key: aListKey,
                  clipBehavior: Clip.none,
                  initialItemCount: LocalAPI().cartItems.length + 1,
                  itemBuilder: (context, i, animation) {
                    try {
                      return AnimationBuilder(i, -50, 0,
                          CartItem(index: i, model: LocalAPI().cartItems[i]));
                    } catch (e) {
                      return Obx(
                        () => LocalAPI().cartItems.isNotEmpty
                            ? AnimationBuilder(i, 0, 50, const VoucherWidget())
                            : const SizedBox(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => LocalAPI().cartItems.isNotEmpty
            ? AnimationBuilder(2, 0, 50, _buildPayBtn())
            : const SizedBox(),
      ),
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
              "${Strs.pay.tr} | ${LocalAPI().cart.finalPrice.toString().trNums().seRagham()} ${Strs.currency.tr}",
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

class VoucherWidget extends HookWidget {
  const VoucherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final isEnableBtn = false.obs;
    final errorText = ''.obs;
    bool isError = true;
    controller.addListener(() {
      isEnableBtn.value = controller.text.isNotEmpty;
    });
    return Column(
      children: [
        const SizedBox(height: 30),
        Divider(
          height: 1,
          endIndent: 20,
          indent: 20,
          color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
        ),
        const SizedBox(height: 30),
        Obx(
          () => TextField(
            controller: controller,
            decoration: InputDecoration(
              errorText: errorText.value.isEmpty ? null : errorText.value,
              errorStyle: TextStyle(
                  color: isError ? Theme.of(context).errorColor : Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              hintText: Strs.iHaveVoucher.tr,
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(
                  () => CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 42, vertical: 7),
                    onPressed: isEnableBtn.value
                        ? () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            try {
                              errorText.value = '';
                              isEnableBtn.value = false;
                              await LocalAPI().applyVoucherToCartBtnOnPressed(
                                  controller.text.trim());
                              isError = false;
                              errorText.value = Strs.voucherApplied.tr;
                            } catch (e) {
                              isError = true;
                              errorText.value = e
                                  .toString()
                                  .replaceAll('Exception:', '')
                                  .trim()
                                  .tr;
                            }
                            isEnableBtn.value = true;
                          }
                        : null,
                    child: Text(
                      Strs.ok.tr,
                      style: CupertinoTheme.of(Get.context!)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontFamily: Get.textTheme.button?.fontFamily,
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${Strs.cartTotal.tr}:",
              style: Get.textTheme.bodyText1,
            ),
            Obx(
              () => Text(
                "${LocalAPI().cart.totalPrice.toString().trNums().seRagham()} ${Strs.currency.tr}",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${Strs.cartTotalDiscount.tr}:",
              style: Get.textTheme.bodyText1,
            ),
            Obx(
              () => Text(
                "${LocalAPI().cart.discount.toString().trNums().seRagham()} ${Strs.currency.tr}",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${Strs.cartTotalPayable.tr}:",
              style: Get.textTheme.bodyText1,
            ),
            Obx(
              () => Text(
                "${LocalAPI().cart.finalPrice.toString().trNums().seRagham()} ${Strs.currency.tr}",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
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
                  RemoveCartItemBtn(
                    aListKey: aListKey,
                    index: index,
                    model: model,
                    child: CartItem(
                      index: index,
                      model: model,
                    ),
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
