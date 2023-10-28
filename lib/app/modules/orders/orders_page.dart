import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/orders/widgets/orders_app_bar.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_customer/app/modules/orders/orders_store.dart';
import 'package:flutter/material.dart';
import 'widgets/order_widget.dart';

class OrdersPage extends StatefulWidget {
  final String title;
  const OrdersPage({Key? key, this.title = 'OrdersPage'}) : super(key: key);
  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends ModularState<OrdersPage, OrdersStore> {
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  User _user = FirebaseAuth.instance.currentUser!;
  int limit = 10;
  double lastExtent = 0;

  @override
  void initState() {
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  addListener() {
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 6;
          lastExtent = scrollController.position.maxScrollExtent;
        });
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Stack(
        children: [
          Observer(
            builder: (context) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("customers")
                    .doc(_user.uid)
                    .collection("orders")
                    .orderBy("created_at", descending: true)
                    // .where("status", whereIn: store.viewableOrderStatus)
                    .limit(limit)
                    .snapshots(),
                builder: (context, snapshot) {
                  print('stream builder');
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }
                  print("docs: ${snapshot.data!.docs.length}");

                  List<DocumentSnapshot> ordersInProgress = [];

                  List<DocumentSnapshot> previousOrders = [];

                  List<String> progressStatuses = [
                    "REQUESTED",
                    "PROCESSING",
                    "SENDED",
                    "DELIVERY_ACCEPTED",
                    "DELIVERY_REQUESTED",
                    "DELIVERY_REFUSED",
                    "TIMEOUT"
                  ];

                  List<String> previousStatuses = [
                    "CANCELED",
                    "REFUSED",
                    "CONCLUDED",
                    "PAYMENT_FAILED"
                  ];

                  snapshot.data!.docs.forEach((doc) {
                    if (progressStatuses.contains(doc.get("status"))) {
                      ordersInProgress.add(doc);
                    } else if (previousStatuses.contains(doc.get("status"))) {
                      previousOrders.add(doc);
                    } else {
                      print(
                          "Documento sem os status previsto: ${doc.id} ${doc.get('status')}");
                    }
                  });

                  return SingleChildScrollView(
                    controller: scrollController,
                    child: snapshot.data!.docs.isEmpty
                        ? EmptyState(
                            height: maxHeight(context),
                            text: "Sem pedidos ainda",
                            icon: Icons.file_copy_outlined,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: viewPaddingTop(context) +
                                      wXD(50, context)),
                              if (ordersInProgress.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: wXD(16, context),
                                      top: wXD(10, context)),
                                  child: Text(
                                    'Em andamento',
                                    style: textFamily(
                                      context,
                                      fontSize: 17,
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.7),
                                    ),
                                  ),
                                ),
                              ...ordersInProgress
                                  .map((order) => OrderWidget(orderDoc: order))
                                  .toList(),
                              if (previousOrders.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: wXD(16, context),
                                      top: wXD(10, context)),
                                  child: Text(
                                    'Anteriores',
                                    style: textFamily(
                                      context,
                                      fontSize: 17,
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.7),
                                    ),
                                  ),
                                ),
                              ...previousOrders
                                  .map((order) => OrderWidget(orderDoc: order))
                                  .toList(),
                              SizedBox(height: wXD(120, context))
                            ],
                          ),
                  );
                },
              );
            },
          ),
          OrdersAppBar(),
        ],
      ),
    );
  }
}
