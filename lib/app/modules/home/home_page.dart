import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/home/home_store.dart';
import 'package:delivery_customer/app/modules/home/widgets/product.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/custom_appbar_with_tabs.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();

  int limit = 16;
  double lastExtent = 0;

  @override
  void initState() {
    store.wasInvitedListen();
    scrollController = ScrollController();
    addListener();
    super.initState();
    // changeStatusBar();
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
          limit += 8;
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

  // getProducts(int limit) async {
  //   List products = [];

  //   QuerySnapshot highlighteds = await FirebaseFirestore.instance
  //       .collection("ads")
  //       .where("online_seller", isEqualTo: true)
  //       .where("status", isEqualTo: "ACTIVE")
  //       .where("paused", isEqualTo: false)
  //       .where("highlighted", isEqualTo: true)
  //       .get();

  //   products = highlighteds.docs;

  //   int _limit = limit - products.length;

  //   FirebaseFirestore.instance
  //       .collection("ads")
  //       .where("online_seller", isEqualTo: true)
  //       .where("status", isEqualTo: "ACTIVE")
  //       .where("paused", isEqualTo: false)
  //       .limit(_limit)
  //       .get();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => store.canBack,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(95, context)),
                Center(
                  child: Observer(
                    builder: (context) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("ads")
                            .where("online_seller", isEqualTo: true)
                            .where("status", isEqualTo: "ACTIVE")
                            .where("paused", isEqualTo: false)
                            .where("category",
                                isEqualTo: store.categorySelected)
                            .orderBy("highlighted", descending: true)
                            .limit(limit)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) {
                            return CenterLoadCircular(
                              // top: maxHeight(context) - (viewPaddingTop(context) + wXD(440, context)),
                            );
                            // return EmptyState(
                            //   height: maxHeight(context) -
                            //       (viewPaddingTop(context) +
                            //           wXD(86, context) +
                            //           wXD(60, context)),
                            //   text: "Sem itens na categoria selecionada",
                            //   icon: Icons.list_alt_rounded,
                            // );
                          }
                          List<DocumentSnapshot> ads = snapshot.data!.docs;
                          if (ads.isEmpty) {
                            if (store.categorySelected != null) {
                              return EmptyState(
                                height: maxHeight(context) -
                                    (viewPaddingTop(context) +
                                        wXD(86, context) +
                                        wXD(60, context)),
                                text: "Sem produtos nesta categoria",
                                icon: Icons.list_alt_rounded,
                              );
                            }
                            return EmptyState(
                              height: maxHeight(context) -
                                  (viewPaddingTop(context) +
                                      wXD(86, context) +
                                      wXD(60, context)),
                              text: "Sem produtos ainda",
                              icon: Icons.list_alt_rounded,
                            );
                            // return Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SizedBox(height: wXD(70, context)),
                            //     Icon(
                            //       Icons.file_copy_outlined,
                            //       size: wXD(90, context),
                            //     ),
                            //     Text("Sem produtos ainda!",
                            //         style: textFamily(context,)),
                            //   ],
                            // );
                          }
                          return Container(
                            width: maxWidth(context),
                            alignment: ads.length == 1
                                ? Alignment.centerLeft
                                : Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: wXD(8, context)),
                            child: Wrap(
                              runSpacing: wXD(4, context),
                              spacing: wXD(8, context),
                              children: ads
                                  .map((ads) => Product(
                                        ads: Ads.fromDoc(
                                          ads,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: wXD(120, context))
              ],
            ),
          ),
          BlackAppBar()
        ],
      ),
    );
  }
}
