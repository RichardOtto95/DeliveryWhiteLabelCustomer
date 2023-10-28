import 'package:delivery_customer/app/modules/cart/cart_Page.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/cart/widgets/finalizing_order.dart';
import 'package:delivery_customer/app/modules/cart/widgets/product.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/order_not_paid.dart';
// import 'widgets/delivery_address.dart';

class CartModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CartStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => CartPage()),
    // ChildRoute('/finalizing', child: (_, args) => FinalizingOrder()),
    ChildRoute('/finalizing', child: (_, args) => FinalizingOrder(
      paymentMethodIsPix: args.data,
    )),
    ChildRoute('/order-not-paid', child: (_, args) => OrderNotPaid(
      orderDoc: args.data,
    )),
    ChildRoute('/product', child: (_, args) => ProductCart(
      adsId: args.data,
    )),
  ];

  @override
  Widget get view => CartPage();
}
