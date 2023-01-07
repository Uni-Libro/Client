import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/book_model.dart';
import '../services/api.dart';
import '../services/local_api.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/books_view.dart/book_img_widget.dart';
import '../widgets/my_app_bar/search_app_bar.dart';
import 'book_screen.dart';

class SearchScn extends StatelessWidget {
  const SearchScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;
    final List<BookModel> result = <BookModel>[].obs;

    Timer? apiCallTimer;
    final isLoading = false.obs;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: CustomScrollView(
            slivers: [
              SearchAppBar(
                onChanged: (value) {
                  apiCallTimer?.cancel();
                  apiCallTimer = Timer(const Duration(milliseconds: 500), () {
                    isLoading.value = true;
                    API().searchBook(value.trim()).then((value) {
                      result.clear();
                      result.addAll(value);
                      isLoading.value = false;
                    });
                  });
                },
                loader: Obx(
                  () => isLoading.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator(
                            minHeight: 2,
                          ),
                        )
                      : const SizedBox(height: 2),
                ),
              ),
              Obx(
                () {
                  result.isEmpty;
                  return SearchList(result: result);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchList extends StatelessWidget {
  const SearchList({
    super.key,
    required this.result,
  });

  final List<BookModel> result;

  @override
  Widget build(BuildContext context) {
    return result.isNotEmpty
        ? AnimationLimiter(
            child: SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimationBuilder(
                  index,
                  50,
                  50,
                  SearchListItem(item: result[index]),
                );
              },
              childCount: result.length,
            )),
          )
        : SliverToBoxAdapter(
            child: Center(
              child: SizedBox.square(
                dimension: Get.width,
                child: Assets.animations.impatientPlaceholder
                    .rive(fit: BoxFit.cover),
              ),
            ),
          );
  }
}

class SearchListItem extends StatelessWidget {
  const SearchListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BookModel item;

  @override
  Widget build(BuildContext context) {
    final tag = UniqueKey();
    return CupertinoButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Get.to(
          () => BookScn(delegate: item, tag: tag),
          duration: const Duration(milliseconds: 800),
        )?.then((value) => Future.delayed(const Duration(milliseconds: 800),
            () => LocalAPI().heroCart.value = ''));
      },
      padding: EdgeInsets.zero,
      child: ListTile(
        visualDensity:
            const VisualDensity(vertical: VisualDensity.maximumDensity),
        isThreeLine: true,
        title: Text(
          item.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${item.authorModels?.map((e) => e.name).join(' | ') ?? ''}\n ${item.categoryModels?.map((e) => e.name).join(' | ') ?? ''}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Hero(
          tag: tag,
          child: BookImgWidget(
            imgUrl: item.imageUrl,
            bR: 10,
          ),
        ),
      ),
    );
  }
}
