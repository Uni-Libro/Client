import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../models/user_model.dart';
import '../../services/api.dart';
import '../../services/local_api.dart';
import '../../services/localization/localization_service.dart';
import '../../services/localization/strs.dart';
import '../../utils/calc_text_size.dart';

RxString eMessage = ''.obs;

class PasswordOption extends StatelessWidget {
  const PasswordOption({
    Key? key,
  }) : super(key: key);

  static const double radius = 13;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.lockBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Text(Strs.editPassword.tr),
      onTap: _onPasswordOptionPressed,
      trailing: RotatedBox(
        quarterTurns:
            LocalizationService.textDirection == TextDirection.rtl ? 0 : 2,
        child: Assets.icons.arrowLeft1TwoTone.svg(
          color: Theme.of(context).colorScheme.onSurface,
          width: 16,
          height: 16,
        ),
      ),
    );
  }

  void _onPasswordOptionPressed() {
    final model = UserModel.create();
    final keyForm = GlobalKey<FormState>();
    eMessage = ''.obs;
    Get.bottomSheet(
      Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Strs.edit.tr} ${Strs.password.tr}',
                  style: Get.textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                _buildPassField(model),
                const SizedBox(height: 25),
                _buildConfirmPassField(model),
                const SizedBox(height: 40),
                _buildErrorPlaceHolder(),
                const SizedBox(height: 25),
                _buildSaveBtn(keyForm, model)
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
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

  Widget _buildErrorPlaceHolder() {
    return Obx(
      () => Visibility(
        visible: eMessage.value.isNotEmpty,
        child: Container(
          decoration: ShapeDecoration(
            color: Get.theme.errorColor.withOpacity(0.3),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              ),
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            eMessage.value.replaceAll('Exception: ', '').tr,
            style: Get.textTheme.caption,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveBtn(GlobalKey<FormState> keyForm, UserModel model) {
    final isProcessing = false.obs;
    final text = Text(
      Strs.save.tr,
      style: CupertinoTheme.of(Get.context!).textTheme.textStyle.copyWith(
            fontFamily: Get.textTheme.button?.fontFamily,
            color: Get.theme.colorScheme.onPrimary,
          ),
    );
    final size = calcTextSize(text);
    return SizedBox(
      width: double.infinity,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 1,
        ),
        child: CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 64),
          child: Obx(
            () => isProcessing.isFalse
                ? text
                : SizedBox(
                    height: size.height,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
          ),
          onPressed: () {
            if (isProcessing.isTrue) return;
            isProcessing.value = true;
            eMessage.value = '';

            _onSaveBtnPressed(keyForm, model, isProcessing);
          },
        ),
      ),
    );
  }

  Future<void> _onSaveBtnPressed(GlobalKey<FormState> keyForm, UserModel model,
      RxBool isProcessing) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 500));

    if (keyForm.currentState?.validate() ?? false) {
      keyForm.currentState?.save();
      try {
        LocalAPI().currentUserProfile = await API().updateProfile(model);
        Get.back();
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
