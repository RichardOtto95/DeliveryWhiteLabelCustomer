import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'root_store.g.dart';

class RootStore = _RootStoreBase with _$RootStore;

abstract class _RootStoreBase with Store {
  // _RootStoreBase() {
  // WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
  //   print(
  //       "Thememode changed: ${WidgetsBinding.instance.window.platformBrightness} ");
  //   if (WidgetsBinding.instance.window.platformBrightness ==
  //       Brightness.light) {
  //     themeMode = ThemeMode.light;
  //   } else if (WidgetsBinding.instance.window.platformBrightness ==
  //       Brightness.dark) {
  //     themeMode = ThemeMode.dark;
  //   }
  // };
  // }

  // @observable
  // ThemeMode themeMode = ThemeMode.system;
}
