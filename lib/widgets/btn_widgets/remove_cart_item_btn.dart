import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../models/book_model.dart';
import '../../services/local_api.dart';
import '../../utils/show_toast.dart';

class RemoveCartItemBtn extends StatelessWidget {
  const RemoveCartItemBtn({
    Key? key,
    required this.aListKey,
    required this.index,
    required this.model,
    required this.child,
  }) : super(key: key);

  final GlobalKey<AnimatedListState> aListKey;
  final int index;
  final BookModel model;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool isProcess = false;
    return StatefulBuilder(builder: (context, setState) {
      return CupertinoButton(
        onPressed: isProcess
            ? null
            : () async {
                setState(() => isProcess = true);
                try {
                  await LocalAPI().removeFromCartBtnOnPressed(
                    aListKey,
                    index,
                    child,
                    model.id!,
                  );
                } catch (e) {
                  showSnackbar(
                      e.toString().replaceAll("Exception:", "").trim().tr,
                      messageType: MessageType.error);
                } finally {
                  setState(() => isProcess = false);
                }
              },
        padding: EdgeInsets.zero,
        child: !isProcess
            ? Assets.icons.trashBulk.svg(color: Colors.red)
            : const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              ),
      );
    });
  }
}
