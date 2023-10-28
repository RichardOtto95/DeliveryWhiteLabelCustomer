import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'shared/color_theme.dart';

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Brightness brightness =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .platformBrightness;

  late ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: "DeliveryApp",
      initialRoute: "/",
    ).modular();
  }
}
