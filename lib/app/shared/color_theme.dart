import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      error: errorLight,
      onError: onErrorLight,
      background: backgroundLight,
      onBackground: onBackgroundLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      shadow: Color(0x30000000),
    ),
    scaffoldBackgroundColor: backgroundLight,
    shadowColor: Color(0x30000000),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      error: errorDark,
      onError: onErrorDark,
      background: backgroundDark,
      onBackground: onBackgroundDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      shadow: Color(0x30000000),
    ),
    scaffoldBackgroundColor: backgroundDark,
    shadowColor: Color(0x30000000),
  );
}

const primaryLight = Color.fromRGBO(255, 0, 0, 1);
const onPrimaryLight = Color.fromRGBO(255, 255, 255, 1);
const secondaryLight = Color.fromRGBO(0, 0, 0, 1);
const onSecondaryLight = Color.fromRGBO(255, 255, 255, 1);
const errorLight = Color.fromRGBO(255, 0, 0, 1);
const onErrorLight = Color.fromRGBO(255, 255, 255, 1);
const backgroundLight = Color.fromRGBO(244, 244, 244, 1);
const onBackgroundLight = Color.fromRGBO(59, 59, 59, 1);
const surfaceLight = Color.fromRGBO(250, 250, 250, 1);
const onSurfaceLight = Color.fromRGBO(118, 118, 118, 1);

const primaryDark = Color.fromRGBO(255, 0, 0, 1);
const onPrimaryDark = Color.fromRGBO(231, 231, 231, 1);
const secondaryDark = Color.fromRGBO(0, 0, 2, 1);
const onSecondaryDark = Color.fromRGBO(254, 254, 254, 1);
const errorDark = Color.fromRGBO(172, 2, 2, 1);
const onErrorDark = Color.fromARGB(255, 8, 0, 0);
const backgroundDark = Color.fromRGBO(59, 59, 59, 1);
const onBackgroundDark = Color.fromRGBO(238, 238, 238, 1);
const surfaceDark = Color.fromRGBO(64, 64, 64, 1);
const onSurfaceDark = Color.fromRGBO(228, 228, 228, 1);

const Color rose = Color(0xffFFDECE);
const Color white = Color(0xffffffff);
const Color lessWhite = Color(0xfffafafa);
const Color grey = Color(0xff707070);
const Color darkGrey = Color(0xff757575);
const Color backgroundGrey = Color(0xfff7f7f7);
const Color veryDarkGrey = Color(0xff757575);
const Color veryVeryDarkGrey = Color(0xff4D4D4D);
const Color lightGrey = Color(0xff898989);
const Color veryLightGrey = Color(0xffD3D3D3);
const Color veryLightOrange = Color(0xffFFF3E4);
const Color green = Color(0xff33C15D);
const Color blue = Color(0xff083BBC);
const Color red = Color(0xffF4282D);
const Color darkBlue = Color(0xff070404);
const Color black = Color(0xff000000);
