import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../models/download_model.dart';
import '../../services/download_service.dart';
import '../../services/local_api.dart';
import '../../utils/extension.dart';
import '../../assets/assets.gen.dart';
import '../../models/book_model.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';
import '../../utils/show_toast.dart';
import '../books_view.dart/book_img_widget.dart';
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
                        child: BookImgWidget(imgUrl: delegate.imageUrl),
                      ),
                    ),
                  ),
                ),
                LocalAPI().currentUsersBooks.any((mb) => mb.id == delegate.id)
                    ? _buildDownloadReadBtn()
                    : _buildBuyBtn(tag),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyBtn(Rx<Object> rTag) {
    final isMyBook =
        LocalAPI().currentUsersBooks.any((mb) => mb.id == delegate.id);
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
          child: isMyBook
              ? Center(
                  child: Text(
                    Strs.purchasedBookMessage.tr,
                    style: Get.textTheme.bodyText2,
                  ),
                )
              : CupertinoButton.filled(
                  onPressed: () async {
                    if (isProcess.value) return;
                    isProcess.value = true;
                    await LocalAPI()
                        .addToCartBookScnBtnOnPressed(rTag, delegate);
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

  Widget _buildDownloadReadBtn() {
    final isLoadLink = Downloader().dQueue.containsKey(delegate.id).obs;
    final Rx<DownloadModel> dModel =
        (Downloader().dQueue[delegate.id]?.key ?? DownloadModel()).obs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Obx(
          () {
            if (isLoadLink.value) {
              switch (dModel.value.status) {
                case DownloadStatus.downloading:
                  return Center(child: _buildDownloadProgressIndicator(dModel));
                case DownloadStatus.failed:
                  Future.delayed(
                    Duration.zero,
                    () => showSnackbar(Strs.downloadFailedError.tr,
                        messageType: MessageType.error),
                  );
                  isLoadLink.value = false;
                  return _buildDownloadBtn(dModel, isLoadLink);
                case DownloadStatus.loading:
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LinearPercentIndicator(
                          lineHeight: 18,
                          barRadius: const Radius.circular(100),
                          backgroundColor: Get.theme.colorScheme.onBackground
                              .withOpacity(0.2),
                          progressColor: Get.theme.colorScheme.primary,
                          addAutomaticKeepAlive: true,
                          animateFromLastPercent: true,
                          isRTL: LocalizationService.textDirection ==
                              TextDirection.rtl,
                        ),
                        const Text(''),
                      ],
                    ),
                  );
                case DownloadStatus.completed:
                  Downloader().openFile(dModel.value);
                  isLoadLink.value = false;
                  return _buildDownloadBtn(dModel, isLoadLink);
                default:
                  isLoadLink.value = false;
                  return _buildDownloadBtn(dModel, isLoadLink);
              }
            } else {
              return _buildDownloadBtn(dModel, isLoadLink);
            }
          },
        ),
      ),
    );
  }

  Obx _buildDownloadProgressIndicator(Rx<DownloadModel> dModel) {
    Widget buildCancelBtn() {
      return CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        child: const Icon(Icons.close_rounded),
        onPressed: () {
          Downloader().cancel(dModel.value);
        },
      );
    }

    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearPercentIndicator(
            lineHeight: 18,
            percent: dModel.value.progress / 100,
            barRadius: const Radius.circular(100),
            animation: true,
            backgroundColor:
                Get.theme.colorScheme.onBackground.withOpacity(0.2),
            progressColor: Get.theme.colorScheme.primary,
            addAutomaticKeepAlive: true,
            animateFromLastPercent: true,
            isRTL: LocalizationService.textDirection == TextDirection.rtl,
            center: Text(
              "${dModel.value.progress.toStringAsFixed(0)}%".trNums(),
            ),
            leading: LocalizationService.textDirection != TextDirection.rtl
                ? null
                : buildCancelBtn(),
            trailing: LocalizationService.textDirection == TextDirection.rtl
                ? null
                : buildCancelBtn(),
          ),
          Text(
            Strs.downloading.tr,
          ),
        ],
      ),
    );
  }

  ClipSmoothRect _buildDownloadBtn(
      Rx<DownloadModel> dModel, RxBool isLoadLink) {
    final isProcess = false.obs;
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: 15,
        cornerSmoothing: 1,
      ),
      child: CupertinoButton.filled(
        onPressed: () {
          if (isProcess.value) return;
          isProcess.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            dModel.value = DownloadModel(
                url: 'http://212.183.159.230/5MB.zip', id: delegate.id);
            isLoadLink.value = true;
            Downloader().getFile(dModel.value);
          });
        },
        child: Obx(
          () => !isProcess.value
              ? Text(
                  Strs.read.tr,
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
    );
  }
}
