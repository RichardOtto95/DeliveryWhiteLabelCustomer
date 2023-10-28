import 'package:flutter_modular/flutter_modular.dart';

import 'sign_up_page.dart';
import 'sign_up_store.dart';

class SignUpModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignUpStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SignUpPage()),
  ];
}
