import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/sign_in_screen.dart';
import '../../services/api.dart';
import '../../services/local_api.dart';
import '../../services/localization/strs.dart';

class SignOutOption extends StatelessWidget {
  const SignOutOption({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Card(
        color: Colors.red,
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(Strs.signOut.tr),
            ),
          ),
        ),
      ),
      onPressed: () {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          API().signOut();
          LocalAPI().clearSecStor();
          Get.offAll(
            const SignInScn(),
            duration: const Duration(milliseconds: 1000),
          );
        });
      },
    );
  }
}
