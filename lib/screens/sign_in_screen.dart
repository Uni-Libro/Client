import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../assets/assets.gen.dart';
import '../models/user_model.dart';
import '../services/api.dart';
import '../services/local_api.dart';
import '../services/localization/localization_service.dart';
import '../services/localization/strs.dart';
import '../widgets/animations/animation_widget.dart';
import 'holder_screen.dart';
import 'sign_up_screen.dart';

RxString eMessage = ''.obs;

class SignInAnimationController {
  StateMachineController? value;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  void dispose() {
    value?.dispose();
  }
}

class SignInScn extends StatefulWidget {
  const SignInScn({super.key});

  @override
  State<SignInScn> createState() => _SignInScnState();
}

class _SignInScnState extends State<SignInScn> {
  final SignInAnimationController _controller = SignInAnimationController();
  final List<FocusNode> focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    super.initState();
    focusNodes[0].addListener(() {
      _controller.isHandsUp?.change(false);
      _controller.trigFail?.change(false);
      _controller.trigSuccess?.change(false);
      _controller.isChecking?.change(focusNodes[0].hasFocus);
    });
    focusNodes[1].addListener(() {
      _controller.trigFail?.change(false);
      _controller.trigSuccess?.change(false);
      _controller.isChecking?.change(false);
      _controller.isHandsUp?.change(focusNodes[1].hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNodes.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimationBuilder(
                0,
                0,
                50,
                SignInAnimationWidget(controller: _controller),
              ),
              AnimationBuilder(
                1,
                0,
                50,
                SignInForm(controller: _controller, focusNodes: focusNodes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInAnimationWidget extends StatelessWidget {
  const SignInAnimationWidget({
    super.key,
    required this.controller,
  });

  final SignInAnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AspectRatio(
        aspectRatio: 1,
        child: Transform.scale(
          scaleX:
              LocalizationService.textDirection == TextDirection.rtl ? -1 : 1,
          child: Assets.animations.loginScreenCharacter.rive(
            fit: BoxFit.fitWidth,
            stateMachines: ['Login Machine'],
            onInit: (artBoard) {
              controller.value = StateMachineController.fromArtboard(
                artBoard,
                'Login Machine',
              );
              if (controller.value == null) return;

              artBoard.addController(controller.value!);
              controller.isChecking = controller.value?.findInput('isChecking');
              controller.numLook = controller.value?.findInput('numLook');
              controller.isHandsUp = controller.value?.findInput('isHandsUp');
              controller.trigSuccess =
                  controller.value?.findInput('trigSuccess');
              controller.trigFail = controller.value?.findInput('trigFail');
            },
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.controller,
    required this.focusNodes,
  });

  final SignInAnimationController controller;
  final List<FocusNode> focusNodes;

  static const radius = 13.0;

  @override
  Widget build(BuildContext context) {
    eMessage = ''.obs;
    final userModel = UserModel();
    final formKey = GlobalKey<FormState>();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: AnimationLimiter(
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
                        children: _getChildren(userModel, formKey))
                    : _getChildren(userModel, formKey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getChildren(UserModel userModel, GlobalKey<FormState> formKey) {
    return [
      const SizedBox(),
      const SizedBox(),
      _buildSignInWithGoogleBtn(),
      const SizedBox(height: 25),
      _buildDivider(),
      const SizedBox(height: 40),
      _buildUsernameEmailField(userModel),
      const SizedBox(height: 25),
      _buildPassField(userModel),
      const SizedBox(height: 15),
      _buildErrorPlaceHolder(),
      const SizedBox(height: 25),
      _buildSignInBtn(formKey, userModel),
      const SizedBox(height: 40),
      _buildAlreadyWarning(),
    ];
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
      onSaved: (value) => model.username = model.email = value,
      focusNode: focusNodes[0],
      onChanged: (value) {
        controller.numLook?.change(value.length.toDouble());
      },
    );
  }

  Widget _buildPassField(UserModel model) {
    final isHide = true.obs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => TextFormField(
            focusNode: focusNodes[1],
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

  Widget _buildSignInBtn(GlobalKey<FormState> keyForm, UserModel model) {
    final isProcessing = false.obs;
    final text = Text(
      Strs.signIn.tr,
      style: CupertinoTheme.of(Get.context!).textTheme.textStyle.copyWith(
            fontFamily: Get.textTheme.button?.fontFamily,
            color: Get.theme.colorScheme.onPrimary,
          ),
    );
    final size = _textSize(text);
    return SizedBox(
      width: double.infinity,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: radius,
          cornerSmoothing: 1,
        ),
        child: CupertinoButton.filled(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 64),
          child: SizedBox(
            height: size.height,
            child: Obx(
              () => isProcessing.isFalse
                  ? text
                  : FittedBox(
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

            _onSignInBtnPressed(keyForm, model, isProcessing);
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
          Strs.dontHaveAnAccount.tr,
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

  Future<void> _onSignInBtnPressed(GlobalKey<FormState> keyForm,
      UserModel model, RxBool isProcessing) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 1000));
    controller.isHandsUp?.change(false);
    controller.isChecking?.change(false);
    controller.trigSuccess?.change(false);
    controller.trigFail?.change(false);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (keyForm.currentState?.validate() ?? false) {
      keyForm.currentState?.save();
      try {
        await LocalAPI().setToken(await API().signIn(model));
        controller.trigSuccess?.change(true);
        await Future.delayed(const Duration(milliseconds: 3000));
        Get.offAll(const HolderScn());
      } on Exception catch (e) {
        controller.trigFail?.change(true);
        eMessage.value = '$e';
      } finally {
        isProcessing.value = false;
      }
    } else {
      controller.trigFail?.change(true);
      isProcessing.value = false;
    }
  }
}

Size _textSize(Text widget, [double? maxWidth]) {
  final textPainter = TextPainter(
    text: TextSpan(text: widget.data, style: widget.style),
    maxLines: widget.maxLines,
    textDirection: widget.textDirection ?? LocalizationService.textDirection,
  )..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
  return textPainter.size;
}
