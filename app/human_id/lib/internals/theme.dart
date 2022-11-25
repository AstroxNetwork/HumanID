import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:human_id/res/fonts.gen.dart';

class HumanIDTheme {
  const HumanIDTheme._();

  static const primaryColor = Color(0xffB5FF26);
  static const errorColor = Color(0xffFF6363);
  static const backgroundColorDark = Color(0xff0b0b0f);
  static const backgroundColorLight = Color(0xfff2f2f6);
  static const cardColorDark = Color(0xff23232f);
  static const cardColorLight = Colors.white;
  static const dividerColorDark = Color(0xff3a3a49);
  static const dividerColorLight = Color(0xffe8eafd);
  static const iconColorDark = Color(0xff5d5d6c);
  static const iconColorLight = Color(0xffc0c0c4);
  static const listColorDark = Color(0xff15151d);
  static const listColorLight = Color(0xfff2f2f2);
  static const primaryTextColorDark = Colors.white;
  static const primaryTextColorLight = Color(0xff3a3a49);
  static const captionTextColorDark = Color(0xff9c9ca4);
  static const captionTextColorLight = captionTextColorDark;
  static const blueGreyIconColorLight = Color(0xffb3b7c1);
  static const blueGreyIconColorDark = Color(0xff6d7793);

  static ThemeData getTheme(Brightness brightness) {
    final isDark = Brightness.dark == brightness;
    final backgroundColor = isDark ? backgroundColorDark : backgroundColorLight;
    final cardColor = isDark ? cardColorDark : cardColorLight;
    final themeData = ThemeData(
      platform: TargetPlatform.iOS,
      brightness: brightness,
      primaryColor: primaryColor,
      cardColor: cardColor,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      }),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        secondary: primaryColor,
        error: errorColor,
        background: backgroundColor,
      ),
      useMaterial3: true,
      fontFamily: FontFamily.pTSans,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primaryColor,
        brightness: brightness,
        scaffoldBackgroundColor: backgroundColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontFamily: FontFamily.pTSans,
            color: cardColorDark,
            fontSize: 18.0,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
          foregroundColor: cardColorDark,
          minimumSize: const Size(0, 48.0),
        ),
      ),
      indicatorColor: primaryColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          textStyle: const TextStyle(
            fontFamily: FontFamily.pTSans,
            color: iconColorDark,
            fontSize: 18.0,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
          foregroundColor: iconColorDark,
          backgroundColor: Colors.transparent,
          minimumSize: const Size(0, 48.0),
        ),
      ),
    );
    return themeData;
  }
}
