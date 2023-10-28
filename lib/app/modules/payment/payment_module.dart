import 'package:delivery_customer/app/modules/payment/payment_Page.dart';
import 'package:delivery_customer/app/modules/payment/payment_store.dart';
import 'package:delivery_customer/app/modules/payment/widgets/card_details.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/add_card.dart';

class PaymentModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PaymentStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => PaymentPage()),
    ChildRoute('/add-card', child: (_, args) => AddCard()),
    ChildRoute(
      '/card-details',
      child: (_, args) => CardDetails(
        args: args.data,
      ),
    ),
  ];

  @override
  Widget get view => PaymentPage();
}
