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

class NameOption extends StatelessWidget {
  const NameOption({
    Key? key,
  }) : super(key: key);

  static const double radius = 13;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Assets.icons.profileBulk
          .svg(color: Theme.of(context).colorScheme.onSurface),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Strs.fullName.tr),
          const SizedBox(width: 25),
          Expanded(
            child: Align(
              alignment: LocalizationService.textDirection == TextDirection.ltr
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Obx(
                () => Text(
                  '${LocalAPI().currentUserProfile.firstName} ${LocalAPI().currentUserProfile.lastName}',
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: _onNameOptionPressed,
      trailing: Assets.icons.edit2Bulk.svg(
        color: Theme.of(context).colorScheme.onSurface,
        width: 16,
        height: 16,
      ),
    );
  }

  void _onNameOptionPressed() {
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
                Text('${Strs.edit.tr} ${Strs.fullName.tr}',
                    style: Get.textTheme.bodyText2),
                const SizedBox(height: 30),
                _buildFNameField(model),
                const SizedBox(height: 25),
                _buildLNameField(model),
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

  Widget _buildLNameField(UserModel model) {
    return TextFormField(
      initialValue: LocalAPI().currentUserProfile.lastName,
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

  Widget _buildFNameField(UserModel model) {
    return TextFormField(
      initialValue: LocalAPI().currentUserProfile.firstName,
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
