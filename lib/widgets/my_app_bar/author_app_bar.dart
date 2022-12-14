import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/author_model.dart';
import '../../assets/assets.gen.dart';
import '../../services/localization/localization_service.dart';
import 'my_app_bar.dart';

class AuthorAppBar extends StatelessWidget {
  const AuthorAppBar({
    Key? key,
    required this.tag,
    required this.delegate,
  }) : super(key: key);

  final Rx<Object> tag;
  final AuthorModel delegate;

  @override
  Widget build(BuildContext context) {
    final expandedH = Get.height * 0.5;
    final collapsedH = Get.height * 0.3;
    return MySliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leadingWidth: 24 + 16 * 2,
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CupertinoButton(
          onPressed: () => Get.back(),
          child: RotatedBox(
            quarterTurns:
                LocalizationService.textDirection == TextDirection.rtl ? 2 : 0,
            child: Assets.icons.arrowLeft1TwoTone.svg(color: Colors.white),
          ),
        ),
      ),
      collapsedHeight: collapsedH,
      expandedHeight: expandedH,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: Stack(
          children: [
            SizedBox.expand(
              child: Hero(
                tag: tag.value,
                child: ClipSmoothRect(
                  radius: const SmoothBorderRadius.vertical(
                    bottom: SmoothRadius(
                      cornerRadius: 30,
                      cornerSmoothing: 1,
                    ),
                  ),
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
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                      topLeft:
                          LocalizationService.textDirection != TextDirection.ltr
                              ? const SmoothRadius(
                                  cornerRadius: 30,
                                  cornerSmoothing: 1,
                                )
                              : SmoothRadius.zero,
                      bottomRight:
                          LocalizationService.textDirection != TextDirection.ltr
                              ? const SmoothRadius(
                                  cornerRadius: 30,
                                  cornerSmoothing: 1,
                                )
                              : SmoothRadius.zero,
                      topRight:
                          LocalizationService.textDirection == TextDirection.ltr
                              ? const SmoothRadius(
                                  cornerRadius: 30,
                                  cornerSmoothing: 1,
                                )
                              : SmoothRadius.zero,
                      bottomLeft:
                          LocalizationService.textDirection == TextDirection.ltr
                              ? const SmoothRadius(
                                  cornerRadius: 30,
                                  cornerSmoothing: 1,
                                )
                              : SmoothRadius.zero,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildBookNamePart(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNamePart() {
    return Text(
      delegate.name!,
      style: Get.textTheme.headline5?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
