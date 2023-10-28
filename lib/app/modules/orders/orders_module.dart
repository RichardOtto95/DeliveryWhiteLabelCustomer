import 'package:delivery_customer/app/modules/orders/orders_Page.dart';
import 'package:delivery_customer/app/modules/orders/orders_store.dart';
import 'package:delivery_customer/app/modules/orders/widgets/shipping_details.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/evaluation.dart';

class OrdersModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => OrdersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => OrdersPage()),
    ChildRoute('/shipping-details',
        child: (_, args) => ShippingDetails(adsOrderId: args.data)),
    ChildRoute('/evaluation', child: (_, args) => Evaluation(model: args.data)),
  ];

  @override
  Widget get view => OrdersPage();
}
