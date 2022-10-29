import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/user_model.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../utils/show_toast.dart';
import 'holder_screen.dart';
import 'sign_up_screen.dart';

class SignInScn extends StatelessWidget {
  const SignInScn({super.key});

  static const radius = 13.0;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final userModel = UserModel();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildTopImg(),
                const SizedBox(height: 30),
                _buildSignInWithGoogleBtn(),
                const SizedBox(height: 25),
                _buildDivider(),
                const SizedBox(height: 40),
                _buildUsernameEmailField(userModel),
                const SizedBox(height: 25),
                _buildPassField(userModel),
                const SizedBox(height: 15),
                _buildSignInBtn(formKey, userModel),
                const SizedBox(height: 40),
                _buildAlreadyWarning(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopImg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child:
          AspectRatio(aspectRatio: 1, child: Assets.images.loginRafiki.svg()),
    );
  }

  Widget _buildUsernameEmailField(UserModel model) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: '${Strs.username.tr}/${Strs.email.tr}',
        errorMaxLines: 10,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '• ${Strs.signInUsernameError.tr}';
        }
        return null;
      },
      onSaved: (value) => model.username = value,
    );
  }

  Widget _buildPassField(UserModel model) {
    final isHide = true.obs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => TextFormField(
            obscureText: isHide.value,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              labelText: Strs.password.tr,
              suffixIcon: GestureDetector(
                child: isHide.value
                    ? const Icon(CupertinoIcons.eye_slash)
                    : const Icon(CupertinoIcons.eye),
                onTap: () {
                  isHide.value = !isHide.value;
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '• ${Strs.signInPasswordError.tr}';
              }
              return null;
            },
            onSaved: (value) => model.password = value,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              minSize: 0,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                Strs.forgotPassword.tr,
                style: Get.textTheme.caption
                    ?.copyWith(fontFamily: LocalizationService.fontFamily),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignInBtn(GlobalKey<FormState> keyForm, UserModel model) {
    return SizedBox(
      width: double.infinity,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 1,
        ),
        child: CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 64),
          child: Text(
            Strs.signIn.tr,
            style: TextStyle(fontFamily: LocalizationService.fontFamily),
          ),
          onPressed: () {
            _onSignInBtnPressed(keyForm, model);
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          thickness: 2,
          indent: 10,
          endIndent: 10,
        )),
        Text(
          Strs.continueWith.tr,
          style: Theme.of(Get.context!).textTheme.caption,
        ),
        const Expanded(
            child: Divider(
          thickness: 2,
          indent: 10,
          endIndent: 10,
        )),
      ],
    );
  }

  Widget _buildSignInWithGoogleBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.googleBulk.svg(
            color: Colors.red.shade600,
            width: 30,
            height: 30,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Assets.icons.facebookBulk.svg(
            color: Colors.blue.shade900,
            width: 30,
            height: 30,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAlreadyWarning() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strs.alreadyHaveAnAccount.tr,
          style: Theme.of(Get.context!).textTheme.caption,
        ),
        CupertinoButton(
          minSize: 0,
          child: Text(
            Strs.signUp.tr,
            style: Theme.of(Get.context!).textTheme.caption?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: LocalizationService.fontFamily,
                ),
          ),
          onPressed: () {
            Get.to(
              const SignUpScn(),
              duration: const Duration(milliseconds: 1000),
            );
          },
        ),
      ],
    );
  }

  void _onSignInBtnPressed(GlobalKey<FormState> keyForm, UserModel model) {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (keyForm.currentState?.validate() ?? false) {
        keyForm.currentState?.save();
        showSnackbar(model.toString(), messageType: MessageType.success);
        Future.delayed(const Duration(milliseconds: 3000), () {
          Get.offAll(
            const HolderScn(),
            duration: const Duration(milliseconds: 1000),
          );
        });
      }
    });
  }
}
