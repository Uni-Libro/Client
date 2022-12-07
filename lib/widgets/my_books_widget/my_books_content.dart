import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/book_model.dart';
import '../../services/localization/strs.dart';
import '../scroll_behavior/scroll_behavior.dart';

class MyBooksContent extends StatelessWidget {
  const MyBooksContent({
    super.key,
    required this.books,
    this.scrollDirection = Axis.horizontal,
  });

  final List<BookModel> books;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              Strs.myBooks.tr,
              style: Get.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoIndicatorScrollBehavior(),
              child: ListView.builder(
                physics: scrollDirection == Axis.horizontal
                    ? const PageScrollPhysics()
                    : null,
                // : const BouncingScrollPhysics(),
                scrollDirection: scrollDirection,
                itemBuilder: (context, index) => SizedBox(
                  height: scrollDirection == Axis.horizontal
                      ? constraints.maxHeight
                      : null,
                  width: scrollDirection == Axis.horizontal
                      ? constraints.maxWidth
                      : null,
                  child: BookItemWidget(
                    bookDelegate: books[index],
                  ),
                ),
                itemCount: books.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookItemWidget extends StatelessWidget {
  const BookItemWidget({
    super.key,
    required this.bookDelegate,
  });

  final BookModel bookDelegate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1.5,
                child: CachedNetworkImage(
                  imageUrl: bookDelegate.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookDelegate.name!,
                    style: Get.textTheme.bodyText2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bookDelegate.authorModels?.map((e) => e.name).join(', ') ?? "",
                    style: Get.textTheme.caption?.copyWith(
                      color: Get.textTheme.headline1?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${bookDelegate.description}\n\n',
                    style: Get.textTheme.overline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
