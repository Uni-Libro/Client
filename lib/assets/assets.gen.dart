/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/book-bulk.svg
  SvgGenImage get bookBulk => const SvgGenImage('assets/icons/book-bulk.svg');

  /// File path: assets/icons/book-twoTone.svg
  SvgGenImage get bookTwoTone =>
      const SvgGenImage('assets/icons/book-twoTone.svg');

  /// File path: assets/icons/category-2-bulk.svg
  SvgGenImage get category2Bulk =>
      const SvgGenImage('assets/icons/category-2-bulk.svg');

  /// File path: assets/icons/category-2-twoTone.svg
  SvgGenImage get category2TwoTone =>
      const SvgGenImage('assets/icons/category-2-twoTone.svg');

  /// File path: assets/icons/facebook-bulk.svg
  SvgGenImage get facebookBulk =>
      const SvgGenImage('assets/icons/facebook-bulk.svg');

  /// File path: assets/icons/google-bulk.svg
  SvgGenImage get googleBulk =>
      const SvgGenImage('assets/icons/google-bulk.svg');

  /// File path: assets/icons/home-1-bulk.svg
  SvgGenImage get home1Bulk =>
      const SvgGenImage('assets/icons/home-1-bulk.svg');

  /// File path: assets/icons/home-1-twoTone.svg
  SvgGenImage get home1TwoTone =>
      const SvgGenImage('assets/icons/home-1-twoTone.svg');

  /// File path: assets/icons/search-normal-bulk.svg
  SvgGenImage get searchNormalBulk =>
      const SvgGenImage('assets/icons/search-normal-bulk.svg');

  /// File path: assets/icons/search-normal-twoTone.svg
  SvgGenImage get searchNormalTwoTone =>
      const SvgGenImage('assets/icons/search-normal-twoTone.svg');

  /// File path: assets/icons/shopping-cart-bulk.svg
  SvgGenImage get shoppingCartBulk =>
      const SvgGenImage('assets/icons/shopping-cart-bulk.svg');

  /// File path: assets/icons/shopping-cart-twoTone.svg
  SvgGenImage get shoppingCartTwoTone =>
      const SvgGenImage('assets/icons/shopping-cart-twoTone.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        bookBulk,
        bookTwoTone,
        category2Bulk,
        category2TwoTone,
        facebookBulk,
        googleBulk,
        home1Bulk,
        home1TwoTone,
        searchNormalBulk,
        searchNormalTwoTone,
        shoppingCartBulk,
        shoppingCartTwoTone
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Login-rafiki.svg
  SvgGenImage get loginRafiki =>
      const SvgGenImage('assets/images/Login-rafiki.svg');

  /// File path: assets/images/Mobile login-pana.svg
  SvgGenImage get mobileLoginPana =>
      const SvgGenImage('assets/images/Mobile login-pana.svg');

  /// File path: assets/images/onBoarding1.png
  AssetGenImage get onBoarding1 =>
      const AssetGenImage('assets/images/onBoarding1.png');

  /// File path: assets/images/onBoarding2.png
  AssetGenImage get onBoarding2 =>
      const AssetGenImage('assets/images/onBoarding2.png');

  /// File path: assets/images/onBoarding3.png
  AssetGenImage get onBoarding3 =>
      const AssetGenImage('assets/images/onBoarding3.png');

  /// List of all assets
  List<dynamic> get values =>
      [loginRafiki, mobileLoginPana, onBoarding1, onBoarding2, onBoarding3];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
