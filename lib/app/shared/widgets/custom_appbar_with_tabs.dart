import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/home/widgets/categories.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/address_model.dart';
import "dart:math" as math;

class BlackAppBar extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).primary),
      child: Container(
        width: maxWidth(context),
        height: MediaQuery.of(context).viewPadding.top + wXD(90, context),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
          color: getColors(context).primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: getColors(context).shadow,
              offset: Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                .collection("customers")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                DocumentSnapshot customerDoc = snapshot.data!;
                if (customerDoc['main_address'] == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: wXD(4, context)),
                      Icon(
                        Icons.location_on,
                        color: getColors(context).onPrimary,
                      ),
                      // SizedBox(width: wXD(2, context)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: TextButton(
                          onPressed: () async => await Modular.to
                              .pushNamed('/address', arguments: false),
                          child: Text(
                            "Cadastrar endereço",
                            maxLines: 1,
                            style: TextStyle(
                              color: getColors(context).onPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("customers")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("addresses")
                        .doc(customerDoc['main_address'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      print(snapshot.data!.data());
                      Address address = Address.fromDoc(snapshot.data!);
                      return InkWell(
                        onTap: () async => await Modular.to
                            .pushNamed('/address', arguments: false),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: wXD(4, context)),
                            Icon(
                              Icons.location_on,
                              color: getColors(context).onPrimary,
                            ),
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: wXD(40, context),
                                  child: Text(address.formatedAddress!,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: getColors(context).onPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: wXD(4, context)),
                            Container(
                              // padding: EdgeInsets.only(left: wXD(30, context)),
                              alignment: Alignment.centerLeft,
                              child: Transform.rotate(
                                angle: math.pi * -.5,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: wXD(25, context),
                                  color: getColors(context).onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: wXD(4, context)),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Spacer(),
            Categories()
          ],
        ),
      ),
    );
  }
}
