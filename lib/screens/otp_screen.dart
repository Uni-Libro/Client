import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../services/localization/localization_service.dart';
import '../utils/extension.dart';
import '../assets/assets.gen.dart';
import '../models/user_model.dart';
import '../services/api.dart';
import '../services/init_app_services.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import '../widgets/my_app_bar/my_app_bar.dart';
import 'holder_screen.dart';

RxString eMessage = ''.obs;
RxBool isProcessing = false.obs;

class OTPScn extends StatelessWidget {
  static const radius = 20.0;
  const OTPScn({
    super.key,
    required this.phone,
  });

  final String phone;

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    final keyForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        leadingWidth: Get.width / 2,
        title: CupertinoButton(
          onPressed: () => Get.back(),
          child: Row(
            children: [
              RotatedBox(
                quarterTurns:
                    LocalizationService.textDirection == TextDirection.rtl
                        ? 2
                        : 0,
                child: Assets.icons.arrowLeft1TwoTone
                    .svg(color: Theme.of(context).colorScheme.onBackground),
              ),
              Text(
                '${Strs.edit.tr} ${Strs.phoneNum.tr}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: keyForm,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              _buildTopImg(),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      _buildTextMessage(),
                      const SizedBox(height: 25),
                      _buildPinPutField(),
                      const SizedBox(height: 25),
                      _buildErrorPlaceHolder(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ))),
    );
  }

  Widget _buildTopImg() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AspectRatio(
        aspectRatio: 1,
        child: Assets.animations.otp.rive(
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildErrorPlaceHolder() {
    return Obx(
      () => isProcessing.value
          ? const CircularProgressIndicator()
          : Visibility(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  eMessage.value.replaceAll('Exception: ', '').tr,
                  style: Get.textTheme.caption,
                ),
              ),
            ),
    );
  }

  Widget _buildPinPutField() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        border:
            Border.all(color: Get.theme.colorScheme.onSurface.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Get.theme.colorScheme.primary),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        showCursor: false,
        closeKeyboardWhenCompleted: true,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        onCompleted: (pin) {
          if (isProcessing.value) return;
          isProcessing.value = true;
          eMessage.value = '';

          _onOTPValidateBtnPressed(pin);
        },
      ),
    );
  }

  Widget _buildTextMessage() {
    return Column(
      children: [
        Text(
          Strs.otpMessage.tr,
          style: Get.textTheme.bodyText1,
        ),
        const SizedBox(height: 10),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            phone.trNums(),
            style:
                Get.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> _onOTPValidateBtnPressed(String pin) async {
    try {
      await LocalAPI()
          .setToken(await API().validateOTPCode(UserModel(phone: phone), pin));
      await loadUserDataFromServer();
      Get.offAll(() =>const HolderScn());
    } on Exception catch (e) {
      eMessage.value = '$e';
    } finally {
      isProcessing.value = false;
    }
  }
}
