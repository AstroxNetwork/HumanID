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
import 'package:lottie/lottie.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  $AssetsIconsAboutGen get about => const $AssetsIconsAboutGen();

  /// File path: assets/icons/arrow_right.svg
  SvgGenImage get arrowRight =>
      const SvgGenImage('assets/icons/arrow_right.svg');

  /// File path: assets/icons/back.svg
  SvgGenImage get back => const SvgGenImage('assets/icons/back.svg');

  /// File path: assets/icons/checked.svg
  SvgGenImage get checked => const SvgGenImage('assets/icons/checked.svg');

  /// File path: assets/icons/failed.svg
  SvgGenImage get failed => const SvgGenImage('assets/icons/failed.svg');

  $AssetsIconsGuideGen get guide => const $AssetsIconsGuideGen();

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');

  $AssetsIconsQrscanGen get qrscan => const $AssetsIconsQrscanGen();

  /// File path: assets/icons/scan.svg
  SvgGenImage get scan => const SvgGenImage('assets/icons/scan.svg');

  /// File path: assets/icons/scan_verify_green.svg
  SvgGenImage get scanVerifyGreen =>
      const SvgGenImage('assets/icons/scan_verify_green.svg');

  /// File path: assets/icons/scan_verify_green_white.svg
  SvgGenImage get scanVerifyGreenWhite =>
      const SvgGenImage('assets/icons/scan_verify_green_white.svg');

  /// File path: assets/icons/scan_verify_red.svg
  SvgGenImage get scanVerifyRed =>
      const SvgGenImage('assets/icons/scan_verify_red.svg');

  /// File path: assets/icons/scan_verify_red_white.svg
  SvgGenImage get scanVerifyRedWhite =>
      const SvgGenImage('assets/icons/scan_verify_red_white.svg');

  /// File path: assets/icons/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/icons/settings.svg');

  /// File path: assets/icons/success.svg
  SvgGenImage get success => const SvgGenImage('assets/icons/success.svg');

  /// File path: assets/icons/unverified_dark.svg
  SvgGenImage get unverifiedDark =>
      const SvgGenImage('assets/icons/unverified_dark.svg');

  /// File path: assets/icons/unverified_light.svg
  SvgGenImage get unverifiedLight =>
      const SvgGenImage('assets/icons/unverified_light.svg');

  /// File path: assets/icons/verified_dark.svg
  SvgGenImage get verifiedDark =>
      const SvgGenImage('assets/icons/verified_dark.svg');

  /// File path: assets/icons/verified_light.svg
  SvgGenImage get verifiedLight =>
      const SvgGenImage('assets/icons/verified_light.svg');

  /// File path: assets/icons/warning_red.svg
  SvgGenImage get warningRed =>
      const SvgGenImage('assets/icons/warning_red.svg');

  /// List of all assets
  List<dynamic> get values => [
        arrowRight,
        back,
        checked,
        failed,
        logo,
        scan,
        scanVerifyGreen,
        scanVerifyGreenWhite,
        scanVerifyRed,
        scanVerifyRedWhite,
        settings,
        success,
        unverifiedDark,
        unverifiedLight,
        verifiedDark,
        verifiedLight,
        warningRed
      ];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/scan.json
  LottieGenImage get scan => const LottieGenImage('assets/lottie/scan.json');

  /// List of all assets
  List<LottieGenImage> get values => [scan];
}

class $AssetsIconsAboutGen {
  const $AssetsIconsAboutGen();

  /// File path: assets/icons/about/discord.svg
  SvgGenImage get discord =>
      const SvgGenImage('assets/icons/about/discord.svg');

  /// File path: assets/icons/about/email.svg
  SvgGenImage get email => const SvgGenImage('assets/icons/about/email.svg');

  /// File path: assets/icons/about/github.svg
  SvgGenImage get github => const SvgGenImage('assets/icons/about/github.svg');

  /// File path: assets/icons/about/medium.svg
  SvgGenImage get medium => const SvgGenImage('assets/icons/about/medium.svg');

  /// File path: assets/icons/about/telegram.svg
  SvgGenImage get telegram =>
      const SvgGenImage('assets/icons/about/telegram.svg');

  /// File path: assets/icons/about/twitter.svg
  SvgGenImage get twitter =>
      const SvgGenImage('assets/icons/about/twitter.svg');

  /// List of all assets
  List<SvgGenImage> get values =>
      [discord, email, github, medium, telegram, twitter];
}

class $AssetsIconsGuideGen {
  const $AssetsIconsGuideGen();

  /// File path: assets/icons/guide/p1.png
  AssetGenImage get p1 => const AssetGenImage('assets/icons/guide/p1.png');

  /// File path: assets/icons/guide/p2.png
  AssetGenImage get p2 => const AssetGenImage('assets/icons/guide/p2.png');

  /// File path: assets/icons/guide/p3.png
  AssetGenImage get p3 => const AssetGenImage('assets/icons/guide/p3.png');

  /// List of all assets
  List<AssetGenImage> get values => [p1, p2, p3];
}

class $AssetsIconsQrscanGen {
  const $AssetsIconsQrscanGen();

  /// File path: assets/icons/qrscan/flashlight_black.svg
  SvgGenImage get flashlightBlack =>
      const SvgGenImage('assets/icons/qrscan/flashlight_black.svg');

  /// File path: assets/icons/qrscan/flashlight_white.svg
  SvgGenImage get flashlightWhite =>
      const SvgGenImage('assets/icons/qrscan/flashlight_white.svg');

  /// File path: assets/icons/qrscan/gallery.svg
  SvgGenImage get gallery =>
      const SvgGenImage('assets/icons/qrscan/gallery.svg');

  /// List of all assets
  List<SvgGenImage> get values => [flashlightBlack, flashlightWhite, gallery];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
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

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(this._assetName);

  final String _assetName;

  LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    LottieDelegates? delegates,
    LottieOptions? options,
    void Function(LottieComposition)? onLoaded,
    LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, LottieComposition?)? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
  }) {
    return Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
