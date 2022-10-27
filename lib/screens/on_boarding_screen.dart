import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class OnBoardingScn extends StatelessWidget {
  const OnBoardingScn({super.key});

  @override
  Widget build(BuildContext context) {
    final introKey = GlobalKey<IntroductionScreenState>();
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        curve: Curves.ease,
        globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        pages: _getOnboardingPages,
        showDoneButton: false,
        showSkipButton: true,
        showNextButton: true,
        overrideNext: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 0.6,
          ),
          child: CupertinoButton.filled(
            padding: EdgeInsets.zero,
            child: Text(Strs.next.tr),
            onPressed: () {
              introKey.currentState?.next();
            },
          ),
        ),
        overrideSkip: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(Strs.skip.tr),
          onPressed: () {
            introKey.currentState?.skipToEnd();
          },
        ),
        dotsDecorator: DotsDecorator(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          size: const Size.square(10),
          activeSize: const Size(20, 10),
          activeColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.259),
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      ),
    );
  }

  List<PageViewModel> get _getOnboardingPages {
    return [
      PageViewModel(
        titleWidget: Text(Strs.onBoardingTitle1.tr,
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          Strs.onBoardingBody1.tr * 5,
          style: Theme.of(Get.context!).textTheme.bodyText1!,
        ),
        image: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 30,
              cornerSmoothing: 1,
            ),
            child: Assets.images.onBoarding1.image(
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        decoration: const PageDecoration(
          contentMargin: EdgeInsets.symmetric(horizontal: 30),
        ),
      ),
      PageViewModel(
        titleWidget: Text(Strs.onBoardingTitle2.tr,
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          Strs.onBoardingBody1.tr * 5,
          style: Theme.of(Get.context!).textTheme.bodyText1!,
        ),
        image: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 30,
              cornerSmoothing: 1,
            ),
            child: Assets.images.onBoarding2.image(
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        decoration: const PageDecoration(
          contentMargin: EdgeInsets.symmetric(horizontal: 30),
        ),
      ),
      PageViewModel(
        titleWidget: Text(Strs.onBoardingTitle3.tr,
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          Strs.onBoardingBody1.tr * 5,
          style: Theme.of(Get.context!).textTheme.bodyText1!,
        ),
        image: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 30,
              cornerSmoothing: 1,
            ),
            child: Assets.images.onBoarding3.image(
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipSmoothRect(
                  radius: SmoothBorderRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 1,
                  ),
                  child: CupertinoButton.filled(
                    child: Text(Strs.signUp.tr),
                    onPressed: () {
                      LocalAPI().isFirstRun = false;
                      Get.off(
                        const SignUpScn(),
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                child: Text(Strs.signIn.tr),
                onPressed: () {
                  LocalAPI().isFirstRun = false;
                  Get.off(
                    const SignInScn(),
                    duration: const Duration(milliseconds: 1000),
                  );
                },
              ),
            ],
          ),
        ),
        decoration: const PageDecoration(
          contentMargin: EdgeInsets.symmetric(horizontal: 30),
        ),
      ),
    ];
  }
}
