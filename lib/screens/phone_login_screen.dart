import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/user_model.dart';
import '../services/api.dart';
import '../services/local_api.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import 'otp_screen.dart';
import 'sign_in_screen.dart';

RxString eMessage = ''.obs;

class PhoneLoginScn extends StatelessWidget {
  static const radius = 20.0;
  const PhoneLoginScn({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTopImg(),
            const Forms(),
          ],
        ),
      ))),
    );
  }

  Widget _buildTopImg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 1,
        child: FittedBox(
          child: Assets.images.loginRafiki.svg(fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class Forms extends StatelessWidget {
  const Forms({
    Key? key,
  }) : super(key: key);

  static const radius = 20.0;

  @override
  Widget build(BuildContext context) {
    final keyForm = GlobalKey<FormState>();
    final model = UserModel();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: keyForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AnimationLimiter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: LocalAPI().isShowAnimation
                  ? AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (child) => SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: child,
                          )),
                      children: _getChildren(model, keyForm))
                  : _getChildren(model, keyForm),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getChildren(UserModel model, GlobalKey<FormState> keyForm) {
    return [
      const SizedBox(height: 25),
      _buildPhoneField(model),
      const SizedBox(height: 30),
      _buildSignInBtn(keyForm, model),
      const SizedBox(height: 20),
      _buildAlreadyWarning(),
    ];
  }

  Widget _buildPhoneField(UserModel model) {
    return TextFormField(
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        hintText: Strs.phoneNum.tr,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Assets.icons.mobileBulk
              .svg(color: Get.theme.colorScheme.onBackground),
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Strs.phoneNumError.tr;
        }
        final validReg = RegExp(r"^(\+?98)?(0?9)\d{9}$");
        if (!validReg.hasMatch(value)) {
          return Strs.phoneNumError.tr;
        }
        return null;
      },
      onSaved: (value) {
        if (value == null) return;
        if (RegExp(r"^9\d{9}$").hasMatch(value)) {
          value = '+98$value';
        } else if (RegExp(r"^09\d{9}$").hasMatch(value)) {
          value = '+98${value.substring(1)}';
        } else if (RegExp(r"^989\d{9}$").hasMatch(value)) {
          value = '+98${value.substring(2)}';
        } else if (RegExp(r"^\+989\d{9}$").hasMatch(value)) {
          value = '+98${value.substring(3)}';
        } else if (RegExp(r"^9809\d{9}$").hasMatch(value)) {
          value = '+98${value.substring(3)}';
        } else if (RegExp(r"^\+9809\d{9}$").hasMatch(value)) {
          value = '+98${value.substring(4)}';
        }
        model.phone = value;
      },
    );
  }

  Widget _buildAlreadyWarning() {
    return CupertinoButton(
      child: Text(
        Strs.loginWithPass.tr,
        style: Theme.of(Get.context!).textTheme.caption?.copyWith(
              color: Theme.of(Get.context!).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontFamily: LocalizationService.fontFamily,
            ),
      ),
      onPressed: () {
        Get.to(
          const SignInScn(),
          duration: const Duration(milliseconds: 1000),
        );
      },
    );
  }

  Widget _buildSignInBtn(GlobalKey<FormState> keyForm, UserModel model) {
    final isProcessing = false.obs;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 1,
        ),
        child: CupertinoButton.filled(
          child: Obx(
            () => isProcessing.isFalse
                ? Text(
                    Strs.signIn.tr,
                    style: CupertinoTheme.of(Get.context!)
                        .textTheme
                        .textStyle
                        .copyWith(
                          fontFamily: Get.textTheme.button?.fontFamily,
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                  )
                : FittedBox(
                    child: CircularProgressIndicator(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
          ),
          onPressed: () {
            if (isProcessing.isTrue) return;
            isProcessing.value = true;
            eMessage.value = '';

            _onSignInBtnPressed(keyForm, model, isProcessing);
          },
        ),
      ),
    );
  }

  Future<void> _onSignInBtnPressed(GlobalKey<FormState> keyForm,
      UserModel model, RxBool isProcessing) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 500));

    if (keyForm.currentState?.validate() ?? false) {
      keyForm.currentState?.save();
      try {
        await AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          body: Column(
            children: [
              Text(
                Strs.correctPhone.tr,
                style: Get.textTheme.bodyText1,
              ),
              const SizedBox(height: 10),
              Text(
                model.phone!,
                style: Get.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          btnCancelText: Strs.no.tr,
          btnOkText: Strs.yes.tr,
          btnCancelOnPress: () {},
          btnOkOnPress: () async {
            if (await API().loginOTP(model)) {
              Get.to(
                OTPScn(phone: model.phone!),
                duration: const Duration(milliseconds: 1000),
              );
            }
          },
        ).show();
      } on Exception catch (e) {
        eMessage.value = '$e';
      } finally {
        isProcessing.value = false;
      }
    } else {
      isProcessing.value = false;
    }
  }
}
