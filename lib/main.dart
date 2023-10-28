import 'package:delivery_customer/app/app_module.dart';
import 'package:delivery_customer/app/app_widget.dart';
import 'package:delivery_customer/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'app/shared/color_theme.dart';
import 'app/shared/utilities.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await FirebaseMessaging.instance.requestPermission();

  Intl.defaultLocale = 'pt_BR';

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  colors = WidgetsBinding.instance.window.platformBrightness == Brightness.light
      ? MyThemes.lightTheme.colorScheme
      : MyThemes.darkTheme.colorScheme;

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
