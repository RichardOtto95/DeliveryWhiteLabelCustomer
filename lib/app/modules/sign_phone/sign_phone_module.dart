import 'package:delivery_customer/app/core/models/customer_model.dart';
import 'package:delivery_customer/app/core/services/auth/auth_service.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/sign_phone/sign_phone_store.dart';
import 'package:delivery_customer/app/modules/sign_phone/widgets/pre_on_boarding.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'sign_page_phone.dart';

class SignPhoneModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => Customer()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => SignPhoneStore()),
    Bind.lazySingleton((i) => AuthService()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => PreOnBoarding()),
    ChildRoute('/sign-phone', child: (_, args) => SignPagePhone()),
  ];

  @override
  Widget get view => SignPagePhone();
}
