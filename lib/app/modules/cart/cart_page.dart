import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_customer/app/modules/cart/widgets/delivery_address_selected.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/cart_appbar.dart';
import 'package:delivery_customer/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';
import 'widgets/accounts.dart';
import 'widgets/items.dart';
import 'widgets/promotional_code.dart';
import 'widgets/shipping_options.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  late OverlayEntry confirmOverlay;
  final _formKey = GlobalKey<FormState>();

  FocusNode promotionalFocus = FocusNode();

  @override
  void initState() {
    scrollController = ScrollController();
    store.assembleList();
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    promotionalFocus.removeListener(() {});
    promotionalFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  addListener() {
    promotionalFocus.addListener(() {
      if (promotionalFocus.hasFocus) {
        mainStore.setVisibleNav(false);
      } else {
        mainStore.setVisibleNav(true);
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
  }

  OverlayEntry getConfirmOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: "Deseja alterar o endereço?",
        onConfirm: () async {
          print('onConfirm');
          confirmOverlay.remove();
          // store.zoomPanBehavior.zoomLevel = 5;
          // store.zoomPanBehavior.focalLatLng = MapLatLng(-15.787763, -48.008072);
          Modular.to.pushNamed('/address', arguments: false);
          // store.mapTileLayerController!.updateMarkers([0]);
          // print('#######################3after edit address##################################');
          // setState(() {});
        },
        onCancel: () => confirmOverlay.remove(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     'build cartPage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    return WillPopScope(
      onWillPop: () async {
        return store.canBack;
        // if (store.redirectOverlay != null) {
        //   if (store.redirectOverlay!.mounted) {
        //     store.redirectOverlay!.remove();
        //   }
        // }
        // return true;
      },
      child: Listener(
        onPointerDown: (a) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: viewPaddingTop(context) + wXD(35, context)),
                  DeliveryAddressSelected(
                    onTap: () {
                      print('onTap');
                      confirmOverlay = getConfirmOverlay();
                      Overlay.of(context)!.insert(confirmOverlay);
                    },
                  ),
                  Observer(
                    builder: (context) {
                      // print('mainStore.cartMap.isEmpty ${store.deliveryType}');
                      if (mainStore.cart.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          mainStore.setVisibleNav(true);
                        });

                        return EmptyState(
                          // top: maxHeight(context),
                          // -
                          //     (viewPaddingTop(context) + wXD(550, context)),
                          text:
                              "Você ainda não possui produtos no seu carrinho",
                          icon: Icons.shopping_cart_outlined,
                        );
                      } else {
                        return Column(
                          children: [
                            Items(
                              onAdd: (String id) {
                                setState(() {
                                  store.addItem(id);
                                });
                              },
                              onClean: (String id) {
                                setState(() {
                                  store.cleanItem(id);
                                });
                              },
                              onRemove: (String id) {
                                setState(() {
                                  store.removeItem(id);
                                });
                              },
                            ),
                            ShippingOptions(),
                            PromotionalCode(
                              focusNode: promotionalFocus,
                              setState: () {
                                setState(() {});
                              },
                            ),
                            PaymentMethodDropDown(
                              formKey: _formKey,
                            ),
                            FutureBuilder<List<num>>(
                              future: store.getSubTotal(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                }
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: wXD(120, context),
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          getColors(context).primary),
                                    ),
                                  );
                                }
                                // print("snapshot: ${snapshot.data}");
                                return Column(
                                  children: [
                                    Accounts(
                                      subTotal: snapshot.data![0],
                                      priceShipping: snapshot.data![1],
                                      priceTotal: snapshot.data![2],
                                      discount: snapshot.data![3],
                                      newPriceTotal: snapshot.data![4],
                                    ),
                                    // MyDropDown(totalPrice: snapshot.data![3],),
                                  ],
                                );
                              },
                            ),
                            Container(
                              width: maxWidth(context),
                              alignment: Alignment.centerRight,
                              child: SideButton(
                                onTap: () async {
                                  // print('_formKey.currentState!.validate() ${_formKey.currentState}');
                                  // if(_formKey.currentState != null){
                                  //   print('_formKey.currentState!.validate() ${_formKey.currentState!.validate()}');

                                  // }
                                  if (_formKey.currentState == null ||
                                      _formKey.currentState!.validate()) {
                                    store.validations(context);
                                  }
                                },
                                // await Modular.to.pushNamed('/cart/finalizing'),
                                title: 'Finalizar',
                                width: wXD(142, context),
                                height: wXD(52, context),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: wXD(120, context)),
                ],
              ),
            ),
            CartAppbar(),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodDropDown extends StatefulWidget {
  final formKey;
  const PaymentMethodDropDown({Key? key, this.formKey}) : super(key: key);

  @override
  State<PaymentMethodDropDown> createState() => _PaymentMethodDropDownState();
}

class _PaymentMethodDropDownState extends State<PaymentMethodDropDown> {
  final CartStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  String dropdownValue = 'Saldo em conta';
  List<String> paymentMethodList = ['Saldo em conta', 'Dinheiro', 'Pix', "Cartão - pelo APP"];
  bool needChange = true;

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter(symbol: 'R\$');

  final FocusNode trocoFocus = FocusNode();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    trocoFocus.addListener(() {
      if (trocoFocus.hasFocus) {
        mainStore.setVisibleNav(false);
      } else {
        mainStore.setVisibleNav(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    trocoFocus.removeListener(() {});
    trocoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('customers')
          .doc(_user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        DocumentSnapshot userDoc = snapshot.data!;
        return Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                wXD(30, context),
                wXD(15, context),
                wXD(20, context),
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forma de pagamento',
                    style: textFamily(
                      context,
                      fontSize: 15,
                      color: getColors(context).onSurface,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: TextStyle(color: getColors(context).onBackground),
                    underline: Container(
                      height: 2,
                      color: getColors(context).primary,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        store.paymentMethod = newValue;
                        needChange = true;
                      });
                    },
                    items: paymentMethodList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: getColors(context).onBackground.withOpacity(.2),
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                left: wXD(30, context),
                bottom: wXD(15, context),
                right: wXD(20, context),
              ),
              height: 100,
              child: dropdownValue == 'Dinheiro'
                ? Row(
                    children: [
                      Text(
                        'Preciso de troco',
                        style: textFamily(
                          context,
                          fontSize: 15,
                          color: getColors(context).onBackground,
                        ),
                      ),
                      Checkbox(
                        activeColor: getColors(context).primary,
                        value: needChange,
                        onChanged: (bool? value) {
                          setState(() {
                            needChange = value!;
                          });
                        },
                      ),
                      Spacer(),
                      needChange
                        ? Form(
                            key: widget.formKey,
                            child: Container(
                              width: wXD(72.5, context),
                              child: TextFormField(
                                focusNode: trocoFocus,
                                inputFormatters: [_formatter],
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'R\$ 00,00',
                                ),
                                validator: (String? value) {
                                  print('value troco: $value');
                                  if (value!.isEmpty) {
                                    return 'Obrigatório!';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  print('onChanged: $value');
                                  print('onChanged: ${_formatter.getUnformattedValue()}');
                                  store.change = _formatter.getUnformattedValue();
                                },
                              ),
                            ),
                          )
                          : Container(),
                    ],
                  )
                : Row(
                    children: [
                      getText(userDoc['account_balance'], userDoc.id),
                    ],
                  ),
            ),
          ],
        );
      },
    );
  }
  Widget getText(num accountBalance, String uid) {
    switch (dropdownValue) {
      case "Saldo em conta":
        return Text(
          dropdownValue + ': ' + 'R\$ ' + formatedCurrency(accountBalance),
          style: textFamily(
            context,
            fontSize: 15,
            color: darkGrey,
          ),
        );

      case "Pix":      
        return SelectableText(
        'Chave pix: cnpj 29.412.420/0001-67',
        style: textFamily(
          context,
          fontSize: 15,
          color: darkGrey,
        ),
      );

      case "Cartão - pelo APP":
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
          .collection("customers")
          .doc(uid)
          .collection("cards")
          .where("status", isEqualTo: "ACTIVE")
          .where("main", isEqualTo: true)
          .get(),
          builder: (context, snapshot) {
            String finalNumber = " ";

            if(snapshot.hasData){
              QuerySnapshot mainCard = snapshot.data!;
              if(mainCard.docs.isNotEmpty){
                DocumentSnapshot card = mainCard.docs.first;
                finalNumber = 'Cartão principal: ${card['final_number']}';
              } else {
                finalNumber = "Sem cartão adicionado";
              }
            }

            return Text(
              finalNumber,
              style: textFamily(
                context,
                fontSize: 15,
                color: darkGrey,
              ),
            );
          }
        );
      default:
        break;
    }
    if (dropdownValue == 'Saldo em conta') {
      return Text(
        dropdownValue + ': ' + 'R\$ ' + formatedCurrency(accountBalance),
        style: textFamily(
          context,
          fontSize: 15,
          color: darkGrey,
        ),
      );
    } else {
      return SelectableText(
        'Chave pix: cnpj 29.412.420/0001-67',
        style: textFamily(
          context,
          fontSize: 15,
          color: darkGrey,
        ),
      );
    }
  }
}
// class MyDropDown extends StatefulWidget {
//   final num totalPrice;
//   const MyDropDown({Key? key, required this.totalPrice}) : super(key: key);

//   @override
//   State<MyDropDown> createState() => _MyDropDownState();
// }

// class _MyDropDownState extends State<MyDropDown> {
//   final CartStore store = Modular.get();
//   String dropdownValue = 'Nenhum';
//   List<String> installmentList = ['Nenhum', '2', '3', '4', '5'];

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: store.getAvailablePlans(),
//       builder: (context, snapshot) {
//         return Container(
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(color: getColors(context).onBackground.withOpacity(.2)),
//             ),
//           ),
//           padding: EdgeInsets.fromLTRB(
//             wXD(30, context),
//             wXD(15, context),
//             wXD(20, context),
//             wXD(15, context),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Parcelamento',
//                     style: textFamily(context,
//                       fontSize: 15,
//                       color: getColors(context).onBackground,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     value: dropdownValue,
//                     icon: const Icon(Icons.arrow_downward),
//                     elevation: 16,
//                     style: const TextStyle(color:getColors(context).primary),
//                     underline: Container(
//                       height: 2,
//                       color:getColors(context).primary,
//                     ),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         dropdownValue = newValue!;
//                         if(newValue == 'Nenhum'){
//                           store.installmentCount = 1;
//                         } else {
//                           store.installmentCount = int.parse(newValue);
//                         }
//                       });
//                     },
//                     items: installmentList.map<DropdownMenuItem<String>>((String value) {
//                       print('list dropdown $value');
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value == 'Nenhum' ? value : value +'x'),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//               dropdownValue != 'Nenhum' ?
//               Text(
//                 dropdownValue + 'x de ' + getPrice(),
//                 style: textFamily(context,
//                   fontSize: 15,
//                   color: getColors(context).onBackground,
//                 ),
//               ) : Container(),
//             ],
//           ),
//         );
//       }
//     );
//   }

//   String getPrice(){
//     int numberInstallments = int.parse(dropdownValue);
//     num response = widget.totalPrice / numberInstallments;
//     return 'R\$' + formatedCurrency(response);
//     // 'R\$${formatedCurrency(subTotal)}'
//   }
// }
