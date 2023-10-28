import 'package:delivery_customer/app/modules/sign_email/sign_email_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'sign_email_page.dart';

class SignEmailModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignEmailStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SignPageEmail()),
  ];
}
