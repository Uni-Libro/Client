import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.gen.dart';
import '../models/user_model.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../utils/show_toast.dart';
import 'sign_in_screen.dart';

class SignUpScn extends StatelessWidget {
  const SignUpScn({super.key});

  static const radius = 13.0;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final signUpModel = UserModel();
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
                _buildSignUpWithGoogleBtn(),
                const SizedBox(height: 25),
                _buildDivider(),
                const SizedBox(height: 40),
                _buildFNameField(signUpModel),
                const SizedBox(height: 25),
                _buildLNameField(signUpModel),
                const SizedBox(height: 25),
                _buildUsernameField(signUpModel),
                const SizedBox(height: 25),
                _buildEmailField(signUpModel),
                const SizedBox(height: 25),
                _buildPassField(signUpModel),
                const SizedBox(height: 25),
                _buildConfirmPassField(signUpModel),
                const SizedBox(height: 40),
                _buildSignUpBtn(formKey, signUpModel),
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
      child: AspectRatio(
          aspectRatio: 1, child: Assets.images.mobileLoginPana.svg()),
    );
  }

  Widget _buildFNameField(UserModel model) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: Strs.firstName.tr,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final validReg = RegExp(r"^[a-zA-Z0-9]+$");
        if (value != null && validReg.hasMatch(value)) return null;
        return '• ${Strs.signUpFNameError.tr}';
      },
      onSaved: (value) => model.firstName = value,
    );
  }

  Widget _buildLNameField(UserModel model) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: Strs.lastName.tr,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final validReg = RegExp(r"^[a-zA-Z0-9]+$");
        if (value != null && validReg.hasMatch(value)) return null;
        return '• ${Strs.signUpLNameError.tr}';
      },
      onSaved: (value) => model.lastName = value,
    );
  }

  Widget _buildUsernameField(UserModel model) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: Strs.username.tr,
        errorMaxLines: 10,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final validReg = RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,}$");
        if (value != null && validReg.hasMatch(value)) return null;
        return '• ${Strs.signUpUsernameError1.tr}\n'
            '• ${Strs.signUpUsernameError2.tr}\n'
            '• ${Strs.signUpUsernameError3.tr}';
      },
      onSaved: (value) => model.username = value,
    );
  }

  Widget _buildEmailField(UserModel model) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: Strs.email.tr,
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final validReg = RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        if (value != null && validReg.hasMatch(value)) return null;
        return '• ${Strs.signUpEmailError.tr}';
      },
      onSaved: (value) => model.email = value,
    );
  }

  Widget _buildPassField(UserModel model) {
    final isHide = true.obs;
    return Obx(
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final validReg =
              RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
          if (value != null && validReg.hasMatch(value)) return null;
          return '• ${Strs.signUpPasswordError1.tr}\n'
              '• ${Strs.signUpPasswordError2.tr}';
        },
        onChanged: (value) => model.password = value,
        onSaved: (value) => model.password = value,
      ),
    );
  }

  Widget _buildConfirmPassField(UserModel model) {
    final isHide = true.obs;
    return Obx(
      () => TextFormField(
        obscureText: isHide.value,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          labelText: Strs.confirmPassword.tr,
          suffixIcon: GestureDetector(
            child: isHide.value
                ? const Icon(CupertinoIcons.eye_slash)
                : const Icon(CupertinoIcons.eye),
            onTap: () {
              isHide.value = !isHide.value;
            },
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != null && value == model.password) return null;
          return '• ${Strs.signUpConfirmPasswordError.tr}';
        },
        onSaved: (value) => model.confirmPassword = value,
      ),
    );
  }

  Widget _buildSignUpBtn(GlobalKey<FormState> keyForm, UserModel model) {
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
            Strs.signUp.tr,
            style: TextStyle(fontFamily: LocalizationService.fontFamily),
          ),
          onPressed: () {
            _onSignUpBtnPressed(keyForm, model);
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

  Widget _buildSignUpWithGoogleBtn() {
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
            Strs.signIn.tr,
            style: Theme.of(Get.context!).textTheme.caption?.copyWith(
                color: Theme.of(Get.context!).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontFamily: LocalizationService.fontFamily),
          ),
          onPressed: () {
            Get.to(
              const SignInScn(),
              duration: const Duration(milliseconds: 1000),
            );
          },
        ),
      ],
    );
  }

  void _onSignUpBtnPressed(GlobalKey<FormState> keyForm, UserModel model) {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (keyForm.currentState?.validate() ?? false) {
        keyForm.currentState?.save();
        showSnackbar(model.toString(), messageType: MessageType.success);
        Future.delayed(const Duration(milliseconds: 3000), () {
          Get.to(
            const SignInScn(),
            duration: const Duration(milliseconds: 1000),
          );
        });
      }
    });
  }
}
