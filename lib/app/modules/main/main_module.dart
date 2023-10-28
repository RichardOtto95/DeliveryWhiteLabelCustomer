import 'package:delivery_customer/app/core/services/auth/auth_service.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/modules/main/main_Page.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/payment/payment_store.dart';
// ignore: implementation_imports
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

// class MainModule extends WidgetModule {
//   @override
//   final List<Bind> binds = [
//     Bind.lazySingleton((i) => MainStore()),
//     Bind.lazySingleton((i) => AuthStore()),
//     Bind.lazySingleton((i) => PaymentStore()),
//     Bind<AuthService>((i) => AuthService()),
//   ];

//   @override
//   final List<ModularRoute> routes = [
//     ChildRoute('/', child: (_, args) => MainPage()),
//   ];

//   @override
//   Widget get view => MainPage();
// }

class MainModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => PaymentStore()),
    Bind<AuthService>((i) => AuthService()),  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MainPage()),
  ];
}
