import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../models/book_model.dart';
import '../../services/local_api.dart';
import '../../utils/show_toast.dart';

class BookmarkBtn extends StatelessWidget {
  const BookmarkBtn({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final BookModel delegate;

  @override
  Widget build(BuildContext context) {
    bool isProcess = false;
    bool isMark = LocalAPI().bookmarkIds.contains(delegate.id);
    return StatefulBuilder(builder: (context, setState) {
      return CupertinoButton(
        onPressed: isProcess
            ? null
            : () async {
                setState(() => isProcess = true);
                try {
                  if (isMark) {
                    await LocalAPI().removeBookmark(delegate.id!);
                    isMark = false;
                  } else {
                    await LocalAPI().addBookmark(delegate.id!);
                    isMark = true;
                  }
                } catch (e) {
                  showSnackbar(
                      e.toString().replaceAll("Exception:", "").trim().tr,
                      messageType: MessageType.error);
                } finally {
                  setState(() => isProcess = false);
                }
              },
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: !isProcess
            ? isMark
                ? Assets.icons.bookmarkBulk
                    .svg(color: Theme.of(context).colorScheme.onBackground)
                : Assets.icons.bookmarkTwoTone
                    .svg(color: Theme.of(context).colorScheme.onBackground)
            : SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
      );
    });
  }
}
