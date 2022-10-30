import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/localization/strs.dart';

class MyBooksContent extends StatelessWidget {
  const MyBooksContent({
    super.key,
    required this.books,
    this.scrollDirection = Axis.horizontal,
  });

  final List<BookItemDelegate> books;
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
            child: ListView.builder(
              physics: scrollDirection == Axis.horizontal
                  ? const PageScrollPhysics()
                  : const BouncingScrollPhysics(),
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

  final BookItemDelegate bookDelegate;

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
                  imageUrl: bookDelegate.imgUrl,
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
                    bookDelegate.name,
                    style: Get.textTheme.headline6,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bookDelegate.authorName,
                    style: Get.textTheme.bodyText1?.copyWith(
                      color: Get.textTheme.headline1?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${bookDelegate.description}\n\n',
                    style: Get.textTheme.bodyText2,
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

class BookItemDelegate {
  final String name;
  final String authorName;
  final String imgUrl;
  final String description;

  BookItemDelegate(this.name, this.authorName, this.imgUrl, this.description);
}
