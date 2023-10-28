import 'package:delivery_customer/app/modules/orders/orders_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrdersAppBar extends StatelessWidget {
  final OrdersStore store = Modular.get();

  OrdersAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Container(
        height: viewPaddingTop(context) + wXD(50, context),
        width: maxWidth(context),
        padding: EdgeInsets.only(
          bottom: wXD(5, context),
          top: viewPaddingTop(context),
          left: wXD(35, context),
          right: wXD(35, context),
        ),
        decoration: BoxDecoration(
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 3),
                color: getColors(context).shadow),
          ],
        ),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Meus pedidos',
              style: textFamily(
                context,
                fontSize: 20,
                color: getColors(context).onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: wXD(10, context)),
            // DefaultTabController(
            //   length: 2,
            //   child: TabBar(
            //     indicatorColor:getColors(context).primary,
            //     indicatorSize: TabBarIndicatorSize.label,
            //     labelPadding: EdgeInsets.symmetric(vertical: 8),
            //     labelColor:getColors(context).primary,
            //     labelStyle: textFamily(context,fontWeight: FontWeight.bold),
            //     unselectedLabelColor: getColors(context).onBackground,
            //     indicatorWeight: 3,
            //     onTap: (value) {
            //       mainStore.setVisibleNav(true);
            //       if (value == 0) {
            //         store.viewableOrderStatus = [
            //           "REQUESTED",
            //           "PROCESSING",
            //           "SENDED",
            //           "DELIVERY_ACCEPTED",
            //           "DELIVERY_REQUESTED",
            //           "DELIVERY_REFUSED",
            //           "TIMEOUT"
            //         ];
            //         inProgress();
            //       } else {
            //         store.viewableOrderStatus = [
            //           "CANCELED",
            //           "REFUSED",
            //           "CONCLUDED",
            //           "PAYMENT_FAILED"
            //         ];
            //         previous();
            //       }
            //     },
            //     tabs: [Text('Em andamento'), Text('Anteriores')],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
