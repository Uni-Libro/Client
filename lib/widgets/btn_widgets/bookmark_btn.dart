import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../assets/assets.gen.dart';
import '../../models/book_model.dart';
import '../../services/api.dart';
import '../../services/local_api.dart';

class BookmarkBtn extends StatelessWidget {
  const BookmarkBtn({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final BookModel delegate;

  @override
  Widget build(BuildContext context) {
    bool isProcess = false;
    bool isMark = LocalAPI().bookmarks.contains(delegate.id);
    return StatefulBuilder(builder: (context, setState) {
      return CupertinoButton(
        onPressed: isProcess
            ? null
            : () async {
                setState(() => isProcess = true);
                try {
                  if (isMark) {
                    await API().removeBookmark(delegate.id!);
                    LocalAPI().bookmarks.remove(delegate.id);
                    isMark = false;
                  } else {
                    await API().addBookmark(delegate.id!);
                    LocalAPI().bookmarks.add(delegate.id!);
                    isMark = true;
                  }
                } catch (e) {
                  print(e);
                }
                setState(() => isProcess = false);
              },
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: isMark
            ? Assets.icons.bookmarkBulk
                .svg(color: Theme.of(context).colorScheme.onBackground)
            : Assets.icons.bookmarkTwoTone
                .svg(color: Theme.of(context).colorScheme.onBackground),
      );
    });
  }
}
