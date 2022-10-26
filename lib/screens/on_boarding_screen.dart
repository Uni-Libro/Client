import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../assets/assets.gen.dart';
import '../services/local_api.dart';
import '../services/localization/strs.dart';

class OnBoardingScn extends StatelessWidget {
  const OnBoardingScn({super.key});

  @override
  Widget build(BuildContext context) {
    final introKey = GlobalKey<IntroductionScreenState>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
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
        titleWidget: Text('Free Payment',
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          'This is tha sample description text. ' * 5,
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
        titleWidget: Text('Online Reading',
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          'This is tha sample description text. ' * 5,
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
        titleWidget: Text('Hear Free Audio Book',
            style: Theme.of(Get.context!).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        bodyWidget: Text(
          'This is tha sample description text. ' * 5,
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
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: Theme.of(Get.context!).colorScheme.primary,
                    shape: SmoothRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(Get.context!).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 15,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Strs.signUp.tr,
                    style: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.onPrimary,
                    ),
                  ),
                ),
                onPressed: () {
                  LocalAPI().isFirstRun = false;
                },
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  LocalAPI().isFirstRun = false;
                },
                padding: EdgeInsets.zero,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(Get.context!).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 15,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(Strs.signIn.tr),
                ),
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
