import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/book_model.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import 'book_screen.dart';

class LibraryScn extends HookWidget {
  const LibraryScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Strs.library.tr),
        bottom: TabBar(
          indicatorColor: Theme.of(context).colorScheme.primary,
          controller: tabController,
          enableFeedback: false,
          tabs: [
            Tab(text: Strs.myBooks.tr),
            Tab(text: Strs.myBookmarks.tr),
          ],
        ),
      ),
      body: AnimationLimiter(
        child: TabBarView(
          controller: tabController,
          children: [
            Center(
              child: Obx(
                () => LocalAPI().currentUsersBooks.isEmpty
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
                                  child: Text(Strs.myBooksIsEmpty.tr,
                                      style: Get.textTheme.bodyText1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LibBookList(
                        books: LocalAPI().currentUsersBooks,
                      ),
              ),
            ),
            Center(
              child: Obx(
                () => LocalAPI().bookmarks.isEmpty
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
                                  child: Text(Strs.bookmarksIsEmpty.tr,
                                      style: Get.textTheme.bodyText1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LibBookList(
                        books: LocalAPI().bookmarks,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LibBookList extends StatelessWidget {
  const LibBookList({
    super.key,
    required this.books,
  });

  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1.6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) =>
          BookGridItem(book: books[index], index: index),
      itemCount: books.length,
    );
  }
}

class BookGridItem extends StatelessWidget {
  const BookGridItem({
    Key? key,
    required this.book,
    required this.index,
  }) : super(key: key);

  final BookModel book;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tag = UniqueKey();
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: 3,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: CupertinoButton(
            onPressed: () {
              Get.to(
                BookScn(delegate: book, tag: tag),
                duration: const Duration(milliseconds: 800),
              )?.then((value) => Future.delayed(
                  const Duration(milliseconds: 800),
                  () => LocalAPI().heroCart.value = ''));
            },
            padding: EdgeInsets.zero,
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
                    imageUrl: book.imageUrl!,
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
