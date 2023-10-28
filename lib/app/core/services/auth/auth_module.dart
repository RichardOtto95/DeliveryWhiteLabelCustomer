// import 'package:delivery_customer/app/core/services/auth/auth_Page.dart';
import 'package:delivery_customer/app/core/services/auth/auth_service.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/modules/sign_phone/sign_phone_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignPhoneStore()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => AuthService()),
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute("/", child: (_, args) => Container()),
  ];
}
