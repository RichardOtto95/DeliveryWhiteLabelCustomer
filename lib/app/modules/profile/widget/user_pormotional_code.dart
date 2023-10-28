import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';

class UserPromotionalCode extends StatelessWidget {
  final ProfileStore store = Modular.get();

  UserPromotionalCode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: viewPaddingTop(context) + wXD(60, context)),
            width: maxWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                brightness == Brightness.light
                    ? Image.asset(
                        './assets/images/logo.png',
                        width: wXD(193, context),
                        height: wXD(173, context),
                      )
                    : Image.asset(
                        './assets/images/logo_dark.png',
                        width: wXD(193, context),
                        height: wXD(173, context),
                      ),
                SizedBox(
                  height: wXD(20, context),
                ),
                FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection("info").get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: wXD(108, context),
                          alignment: Alignment.center,
                          child: LinearProgressIndicator(
                            color: getColors(context).primary,
                            backgroundColor:
                                getColors(context).primary.withOpacity(0.4),
                          ),
                        );
                      }
                      QuerySnapshot infoQuery = snapshot.data!;
                      DocumentSnapshot infoDoc = infoQuery.docs.first;

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: wXD(45, context)),
                        child: Column(
                          children: [
                            Text(
                              infoDoc['invite_friend_page_title'],
                              textAlign: TextAlign.center,
                              style: textFamily(context, fontSize: 20),
                            ),
                            SizedBox(
                              height: wXD(30, context),
                            ),
                            Text(
                              infoDoc['invite_friend_page_description'],
                              textAlign: TextAlign.justify,
                              style: textFamily(
                                context,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: wXD(40, context),
                            ),
                          ],
                        ),
                      );
                    }),
                Container(
                  width: maxWidth(context),
                  margin: EdgeInsets.symmetric(horizontal: wXD(75, context)),
                  padding: EdgeInsets.symmetric(
                      horizontal: wXD(8, context), vertical: wXD(5, context)),
                  // height: wXD(200, context),
                  decoration: BoxDecoration(
                    border: Border.all(color: getColors(context).primary),
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                  ),
                  child:
                      //  FutureBuilder<DocumentSnapshot>(
                      //     future: FirebaseFirestore.instance
                      //         .collection('customers')
                      //         .doc(_user!.uid)
                      //         .get(),
                      //     builder: (context, snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return LinearProgressIndicator(
                      //           color: getColors(context).primary,
                      //           backgroundColor:
                      //               getColors(context).primary.withOpacity(0.5),
                      //         );
                      //       }
                      //       DocumentSnapshot _userDoc = snapshot.data!;
                      //       return
                      Text(
                    // _userDoc['user_promotional_code'],
                    store.profileEdit['user_promotional_code'],
                    textAlign: TextAlign.center,
                    style: textFamily(
                      context,
                      fontSize: 20,
                    ),
                    //         );
                    //       }
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          DefaultAppBar("Convide os seus amigos")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getColors(context).primary,
        onPressed: () {
          store.share();
        },
        child: Icon(Icons.share_rounded),
      ),
    );

    // return WillPopScope(
    //   onWillPop: () async {
    //     return true;
    //   },
    //   child: Listener(
    //     onPointerDown: (a) =>
    //         FocusScope.of(context).requestFocus(new FocusNode()),
    //     child: Material(
    //       child: Stack(
    //         children: [
    //           Container(
    //             padding:
    //                 EdgeInsets.only(top: wXD(53, context) + statusBarHeight),
    //             width: maxWidth(context),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Image.asset(
    //                   './assets/images/logo.png',
    //                   width: wXD(173, context),
    //                   height: wXD(153, context),
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 FutureBuilder<QuerySnapshot>(
    //                   future: FirebaseFirestore.instance.collection("info").get(),
    //                   builder: (context, snapshot) {
    //                     if(!snapshot.hasData){
    //                       return LinearProgressIndicator(
    //                         color:getColors(context).primary,
    //                         backgroundColor:getColors(context).primary.withOpacity(0.4),
    //                       );
    //                     }
    //                     QuerySnapshot infoQuery = snapshot.data!;
    //                     DocumentSnapshot infoDoc = infoQuery.docs.first;

    //                     return Column(
    //                       children: [
    //                         Text(
    //                           infoDoc['invite_friend_page_title'],
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             fontSize: 20,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 15,
    //                         ),
    //                         Text(
    //                           infoDoc['invite_friend_page_description'],
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 15,
    //                         ),
    //                       ],
    //                     );
    //                   }
    //                 ),
    //                 Container(
    //                   width: maxWidth(context),
    //                   margin:
    //                       EdgeInsets.symmetric(horizontal: wXD(75, context)),
    //                   padding: EdgeInsets.symmetric(
    //                       horizontal: wXD(8, context),
    //                       vertical: wXD(5, context)),
    //                   // height: wXD(200, context),
    //                   decoration: BoxDecoration(
    //                     border: Border.all(color:getColors(context).primary),
    //                     borderRadius: BorderRadius.all(Radius.circular(90)),
    //                   ),
    //                   child: FutureBuilder<DocumentSnapshot>(
    //                       future: FirebaseFirestore.instance
    //                           .collection('customers')
    //                           .doc(_user!.uid)
    //                           .get(),
    //                       builder: (context, snapshot) {
    //                         if (snapshot.connectionState ==
    //                             ConnectionState.waiting) {
    //                           return LinearProgressIndicator(
    //                             color:getColors(context).primary,
    //                             backgroundColor:getColors(context).primary.withOpacity(0.5),
    //                           );
    //                         }
    //                         DocumentSnapshot _userDoc = snapshot.data!;
    //                         return Text(
    //                           _userDoc['user_promotional_code'],
    //                           textAlign: TextAlign.center,
    //                         );
    //                       }),
    //                 ),
    //                 SizedBox(
    //                   height: 15,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           UserPromotionalCodeAppBar(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
