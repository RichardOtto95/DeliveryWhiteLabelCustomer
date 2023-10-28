import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/home/widgets/product.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final ScrollController scrollController = ScrollController();
  User _user = FirebaseAuth.instance.currentUser!;

  int limit = 16;
  double lastExtent = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 10;
          lastExtent = scrollController.position.maxScrollExtent;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainStore mainStore = Modular.get();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                Center(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("customers")
                          .doc(_user.uid)
                          .collection("favorites")
                          .limit(limit)
                          .snapshots(),
                      builder: (context, favSnap) {
                        if (!favSnap.hasData) {
                          return CenterLoadCircular();
                        }
                        final ids = [];
                        for (var fav in favSnap.data!.docs) {
                          ids.add(fav.id);
                        }
                        if (ids.isEmpty) {
                          return EmptyState(
                            text: "Sem produtos ainda",
                            icon: Icons.file_copy_outlined,
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
                          //         style: textFamily(
                          //           context,
                          //         )),
                          //   ],
                          // );
                        }
                        print('ids: $ids');
                        return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("ads")
                                .where("id", whereIn: ids)
                                .where("status", isNotEqualTo: "DELETED")
                                .where("paused", isEqualTo: false)
                                // .orderBy("highlighted", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              List<DocumentSnapshot> ads = snapshot.data!.docs;
                              if (ads.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: wXD(70, context)),
                                    Icon(
                                      Icons.file_copy_outlined,
                                      size: wXD(90, context),
                                    ),
                                    Text("Sem produtos ainda!",
                                        style: textFamily(
                                          context,
                                        )),
                                  ],
                                );
                              }
                              return Wrap(
                                  runSpacing: wXD(4, context),
                                  spacing: wXD(4, context),
                                  children: ads
                                      .map((ads) => Product(
                                            ads: Ads.fromDoc(
                                              ads,
                                            ),
                                          ))
                                      .toList());
                            });
                      }),
                ),
                SizedBox(height: wXD(120, context))
              ],
            ),
          ),
          DefaultAppBar('Favoritos')
        ],
      ),
    );
  }
}
