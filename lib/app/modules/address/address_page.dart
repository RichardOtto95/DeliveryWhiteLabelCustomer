import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/modules/cart/widgets/delivery_search_field.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_customer/app/modules/address/address_store.dart';
import 'package:flutter/material.dart';
import 'widgets/address.dart';
import 'widgets/address_edition.dart';
import 'widgets/address_popup.dart';

class AddressPage extends StatefulWidget {
  final bool signRoot;

  AddressPage({Key? key, this.signRoot = false}) : super(key: key);
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends ModularState<AddressPage, AddressStore> {
  final MainStore mainStore = Modular.get();
  final AddressStore addressStore = Modular.get();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    if (widget.signRoot) {
      showToast("Defina um endereço para continuar");
    }
    super.initState();
  }

  getAdressPopUpOverlay(Address addressModel, context) {
    store.editAddressOverlay = OverlayEntry(
      builder: (ovContext) => AddressPopUp(
        model: addressModel,
        onCancel: () {
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
        },
        onEdit: () {
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
          store.addresEditionOverlay = OverlayEntry(
            builder: (oContext) => AddressEdition(
              address: addressModel,
              onBack: (Address? address) {
                if (address != null) {
                  print("Modular: ${Modular.to.path}");
                  Modular.to.pushNamed(
                    "/address/place-picker",
                    arguments: {
                      "address": address,
                      "editing": true,
                    },
                  );
                }
                store.addresEditionOverlay!.remove();
                store.addresEditionOverlay = null;
              },
              editing: true,
            ),
          );
          Overlay.of(context)!.insert(store.addresEditionOverlay!);
        },
        onDelete: () async {
          await store.deleteAddress(context, addressModel);
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
        },
      ),
    );
    Overlay.of(context)!.insert(store.editAddressOverlay!);
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        if (mainStore.globalOverlay != null) {
          mainStore.globalOverlay!.remove();
          mainStore.globalOverlay = null;
          return false;
        }

        if (store.editAddressOverlay != null) {
          store.editAddressOverlay!.remove();
          store.editAddressOverlay = null;
          return false;
        }

        if (store.addresEditionOverlay != null) {
          store.addresEditionOverlay!.remove();
          store.addresEditionOverlay = null;
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: maxHeight(context),
              width: maxWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                    DeliverySearchField(
                      onTap: () async {
                        Modular.to.pushNamed("/address/place-picker", arguments: {
                          "address": Address(),
                          "editing": false,
                        });
                      },
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                        .collection("customers")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("addresses")
                        .where("status", isEqualTo: "ACTIVE")
                        .orderBy("main", descending: true)
                        .orderBy("created_at", descending: true)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasError){
                          print(snapshot.error);
                        }

                        if (!snapshot.hasData) {
                          return CenterLoadCircular();
                        }

                        QuerySnapshot addresses = snapshot.data!;
                        store.hasAddress = addresses.docs.length != 0;
                        if (addresses.docs.isEmpty) {
                          return EmptyState(
                            height: maxHeight(context) -
                                (viewPaddingTop(context) + wXD(200, context)),
                            text: "Sem endereços ainda",
                            icon: Icons.email_outlined,
                          );
                        }
                        return Column(
                          children: addresses.docs.map((address) => AddressWidget(
                            model: Address.fromDoc(address),
                            iconTap: () {
                              getAdressPopUpOverlay(Address.fromDoc(address), context);
                            },
                          )).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: DefaultAppBar(
                'Endereço de entrega',
              ),
            ),
            Visibility(
              visible: widget.signRoot && store.hasAddress,
              child: Positioned(
                bottom: wXD(50, context),
                right: 0,
                child: SideButton(
                  title: "Continuar",
                  height: wXD(52, context),
                  width: wXD(120, context),
                  onTap: () => Modular.to.pushNamed("/main"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}