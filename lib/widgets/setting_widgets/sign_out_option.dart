import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/phone_login_screen.dart';
import '../../services/api.dart';
import '../../services/local_api.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';

class SignOutOption extends StatelessWidget {
  const SignOutOption({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _onSignOutBtnPressed,
      child: Card(
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(Strs.signOut.tr,
                  style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignOutBtnPressed() {
    showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: CupertinoActionSheet(
            title: Text(
              Strs.signOut.tr,
              style: TextStyle(fontFamily: LocalizationService.fontFamily),
            ),
            message: Text(
              Strs.signOutWarning.tr,
              style: TextStyle(fontFamily: LocalizationService.fontFamily),
            ),
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  Strs.ok.tr,
                  style: TextStyle(fontFamily: LocalizationService.fontFamily),
                ),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 500))
                      .then((value) {
                    API().signOut();
                    LocalAPI().clearSecStor();
                    Get.back();
                    Get.offAll(
                      () => const PhoneLoginScn(),
                      duration: const Duration(milliseconds: 1000),
                    );
                  });
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                Strs.cancel.tr,
                style: TextStyle(fontFamily: LocalizationService.fontFamily),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        );
      },
    );
  }
}
