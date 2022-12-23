import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/book_model.dart';
import '../services/api.dart';
import '../services/localization/strs.dart';
import '../widgets/animations/animation_widget.dart';
import '../widgets/books_view.dart/book_img_widget.dart';
import '../widgets/my_app_bar/search_app_bar.dart';

class SearchScn extends StatelessWidget {
  const SearchScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;
    final List<BookModel> result = <BookModel>[].obs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomScrollView(
            slivers: [
              SearchAppBar(
                onSubmitted: (value) {
                  value = value.trim();
                  result.clear();
                  API().searchBook(value).then((value) {
                    result.addAll(value);
                  });
                },
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
                child: Stack(
                  children: [
                    Assets.animations.impatientPlaceholder
                        .rive(fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.width * 0.25),
                        child: Text(Strs.bookmarksIsEmpty.tr,
                            style: Get.textTheme.bodyText1),
                      ),
                    ),
                  ],
                ),
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
    return ListTile(
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
      leading: BookImgWidget(imgUrl: item.imageUrl, bR: 10),
    );
  }
}
