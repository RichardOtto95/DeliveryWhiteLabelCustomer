// ignore: implementation_imports
import 'package:flutter_modular/flutter_modular.dart';

import 'messages_page.dart';
import 'messages_store.dart';
import 'widgets/chat.dart';

class MessagesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MessagesStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MessagesPage()),
    ChildRoute(
      '/chat',
      child: (_, args) => Chat(
        receiverCollection: args.data["receiverCollection"],
        receiverId: args.data["receiverId"],
        messageId: args.data["messageId"] ?? "",
      ),
    ),
  ];
}
