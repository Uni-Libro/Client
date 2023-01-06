import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/author_model.dart';
import '../services/api.dart';
import '../services/localization/strs.dart';
import '../widgets/books_view.dart/books_view.dart';
import '../widgets/my_app_bar/author_app_bar.dart';

class AuthorScn extends StatelessWidget {
  const AuthorScn({
    super.key,
    required this.delegate,
    required this.tag,
  });

  final AuthorModel delegate;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final rTag = tag.obs;
    final isShowAppBarTitle = false.obs;
    return Scaffold(
      body: ScrollableBody(
        tag: rTag,
        delegate: delegate,
        isShowAppBarTitle: isShowAppBarTitle,
      ),
    );
  }
}

class ScrollableBody extends StatelessWidget {
  const ScrollableBody({
    Key? key,
    required this.tag,
    required this.delegate,
    required this.isShowAppBarTitle,
  }) : super(key: key);

  final Rx<Object> tag;
  final AuthorModel delegate;
  final RxBool isShowAppBarTitle;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        AuthorAppBar(
          tag: tag,
          delegate: delegate,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                child: Column(
                  children: [
                    _buildDescPart(),
                    const SizedBox(height: 40),
                    _buildSpecialsBooksView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescPart() {
    return Text(
      delegate.description!,
      style: Get.textTheme.bodyText1,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildSpecialsBooksView() {
    return FutureBuilder(
      future: API().getAuthorById(delegate.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BooksView(
            position: 0,
            title: Strs.authorBooks.tr,
            delegates: (snapshot.data as AuthorModel).books!,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
