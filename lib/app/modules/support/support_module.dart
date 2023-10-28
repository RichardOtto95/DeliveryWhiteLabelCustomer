import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/modules/support/support_store.dart';
// ignore: implementation_imports
import 'package:flutter_modular/flutter_modular.dart';

import 'support_chat.dart';
import 'support_page.dart';

class SupportModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SupportStore()),
    Bind.lazySingleton((i) => ProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SupportPage()),
    ChildRoute("/support-chat", child: (_, args) => SupportChat())
  ];
}
