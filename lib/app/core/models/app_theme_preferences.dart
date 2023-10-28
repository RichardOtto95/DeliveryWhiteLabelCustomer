import 'dart:io';
import 'package:flutter/material.dart';

class AppThemePreferences {
  BuildContext context;

  String storeName;
  File? logotipo;
  File? logo;
  File? typography;

  ColorsPreferences colors;

  TextStylePreferences textStylePreferences;

  AppBarParams appBarParams;

  AppThemePreferences({
    required this.context,
    required this.storeName,
    this.logotipo,
    this.logo,
    this.typography,
    required this.colors,
    required this.textStylePreferences,
    required this.appBarParams,
  });

  ThemeData toThemeData() {
    final brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .platformBrightness;
    return ThemeData(
        colorScheme: brightness == Brightness.light
            ? ColorScheme(
                brightness: brightness,
                primary: colors.primaryLight!,
                onPrimary: colors.onPrimaryLight!,
                secondary: colors.secondaryLight!,
                onSecondary: colors.onSecondaryLight!,
                error: colors.errorLight!,
                onError: colors.onErrorLight!,
                background: colors.backgroundLight!,
                onBackground: colors.onBackgroundLight!,
                surface: colors.surfaceLight!,
                onSurface: colors.onSurfaceLight!,
              )
            : ColorScheme(
                brightness: brightness,
                primary: colors.primaryDark!,
                onPrimary: colors.primaryDark!,
                secondary: colors.secondaryDark!,
                onSecondary: colors.secondaryDark!,
                error: colors.errorDark!,
                onError: colors.errorDark!,
                background: colors.backgroundDark!,
                onBackground: colors.backgroundDark!,
                surface: colors.surfaceDark!,
                onSurface: colors.surfaceDark!,
              ),
        textTheme: TextTheme(
          titleLarge: textStylePreferences.titleLarge,
          titleMedium: textStylePreferences.titleMedium,
          titleSmall: textStylePreferences.titleSmall,
          labelLarge: textStylePreferences.labelLarge,
          labelMedium: textStylePreferences.labelMedium,
          labelSmall: textStylePreferences.labelSmall,
          displayLarge: textStylePreferences.displayLarge,
          displayMedium: textStylePreferences.displayMedium,
          displaySmall: textStylePreferences.displaySmall,
        ));
  }
}

class ColorsPreferences {
  BuildContext context;

  Color? primaryLight;
  Color? secondaryLight;
  Color? backgroundLight;
  Color? surfaceLight;
  Color? errorLight;
  Color? onPrimaryLight;
  Color? onSecondaryLight;
  Color? onBackgroundLight;
  Color? onSurfaceLight;
  Color? onErrorLight;

  Color? primaryDark;
  Color? secondaryDark;
  Color? backgroundDark;
  Color? surfaceDark;
  Color? errorDark;
  Color? onPrimaryDark;
  Color? onSecondaryDark;
  Color? onBackgroundDark;
  Color? onSurfaceDark;
  Color? onErrorDark;

  ColorsPreferences(
    this.context, {
    this.onPrimaryLight,
    this.onSecondaryLight,
    this.onBackgroundLight,
    this.onSurfaceLight,
    this.onErrorLight,
    this.onPrimaryDark,
    this.onSecondaryDark,
    this.onBackgroundDark,
    this.onSurfaceDark,
    this.onErrorDark,
    this.primaryLight,
    this.secondaryLight,
    this.backgroundLight,
    this.surfaceLight,
    this.errorLight,
    this.primaryDark,
    this.secondaryDark,
    this.backgroundDark,
    this.surfaceDark,
    this.errorDark,
  }) {
    primaryLight = primaryLight ?? Theme.of(context).colorScheme.primary;
    secondaryLight = secondaryLight ?? Theme.of(context).colorScheme.secondary;
    backgroundLight =
        backgroundLight ?? Theme.of(context).colorScheme.background;
    surfaceLight = surfaceLight ?? Theme.of(context).colorScheme.surface;
    errorLight = errorLight ?? Theme.of(context).colorScheme.error;
    primaryDark = primaryDark ?? Theme.of(context).colorScheme.primary;
    secondaryDark = secondaryDark ?? Theme.of(context).colorScheme.secondary;
    backgroundDark = backgroundDark ?? Theme.of(context).colorScheme.background;
    surfaceDark = surfaceDark ?? Theme.of(context).colorScheme.surface;
    errorDark = errorDark ?? Theme.of(context).colorScheme.error;
    onPrimaryLight = onPrimaryLight ?? Theme.of(context).colorScheme.onPrimary;
    onSecondaryLight =
        onSecondaryLight ?? Theme.of(context).colorScheme.onSecondary;
    onBackgroundLight =
        onBackgroundLight ?? Theme.of(context).colorScheme.onBackground;
    onSurfaceLight = onSurfaceLight ?? Theme.of(context).colorScheme.onSurface;
    onErrorLight = onErrorLight ?? Theme.of(context).colorScheme.onError;
    onPrimaryDark = onPrimaryDark ?? Theme.of(context).colorScheme.onPrimary;
    onSecondaryDark =
        onSecondaryDark ?? Theme.of(context).colorScheme.onSecondary;
    onBackgroundDark =
        onBackgroundDark ?? Theme.of(context).colorScheme.onBackground;
    onSurfaceDark = onSurfaceDark ?? Theme.of(context).colorScheme.onSurface;
    onErrorDark = onErrorDark ?? Theme.of(context).colorScheme.onError;
  }
}

class TextStylePreferences {
  BuildContext context;

  TextStyle? titleLarge;
  TextStyle? titleMedium;
  TextStyle? titleSmall;

  TextStyle? labelLarge;
  TextStyle? labelMedium;
  TextStyle? labelSmall;

  TextStyle? displayLarge;
  TextStyle? displayMedium;
  TextStyle? displaySmall;

  TextStylePreferences(
    this.context, {
    this.titleLarge,
    this.titleMedium,
    this.titleSmall,
    this.labelLarge,
    this.labelMedium,
    this.labelSmall,
    this.displayLarge,
    this.displayMedium,
    this.displaySmall,
  }) {
    titleLarge = titleLarge ?? Theme.of(context).textTheme.titleLarge;
    titleMedium = titleMedium ?? Theme.of(context).textTheme.titleMedium;
    titleSmall = titleSmall ?? Theme.of(context).textTheme.titleSmall;
    labelLarge = labelLarge ?? Theme.of(context).textTheme.labelLarge;
    labelMedium = labelMedium ?? Theme.of(context).textTheme.labelMedium;
    labelSmall = labelSmall ?? Theme.of(context).textTheme.labelSmall;
    displayLarge = displayLarge ?? Theme.of(context).textTheme.displayLarge;
    displayMedium = displayMedium ?? Theme.of(context).textTheme.displayMedium;
    displaySmall = displaySmall ?? Theme.of(context).textTheme.displaySmall;
  }
}

class AppBarParams {
  double height;
  BorderRadius? borderRadius;
  Widget? action;
  Widget? leading;
  String title;

  AppBarParams({
    Key? key,
    this.height = 70,
    this.borderRadius,
    this.action,
    this.leading,
    this.title = "Nome da loja",
  });
}
