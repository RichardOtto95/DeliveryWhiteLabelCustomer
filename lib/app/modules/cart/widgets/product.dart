import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/product/widgets/characteristics.dart';
import 'package:delivery_customer/app/shared/additional_models/text_area.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/additional_models/check_box.dart';
import '../../../shared/additional_models/combo_box.dart';
import '../../../shared/additional_models/increment_field.dart';
import '../../../shared/additional_models/radio_button.dart';
import '../../../shared/additional_models/text_field_score.dart';
import '../../../shared/additional_models/text_score.dart';
import '../../../shared/color_theme.dart';
import '../../product/widgets/item_data.dart';

class ProductCart extends StatefulWidget {
  final String adsId;

  const ProductCart({Key? key, required this.adsId}) : super(key: key);
  @override
  State<ProductCart> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductCart> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ads')
                    .doc(widget.adsId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  } else {
                    Ads model = Ads.fromDoc(snapshot.data!);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: viewPaddingTop(context) + wXD(60, context),
                          ),
                          ItemData(model: model),
                          Characteristics(model: model),
                          // StoreInformations(
                          //   sellerId: model.sellerId,
                          //   adsId: model.id,
                          // ),
                          ProductInformations(adsModel: model),
                          // AddToCart(adsModel: model),
                          // Opinions(model: model),
                          SizedBox(
                            height: wXD(25, context),
                            width: maxWidth(context),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Anúncio #${model.id.substring(0, 10).toUpperCase()}',
                                      style: textFamily(
                                        context,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: wXD(25, context),
                                  color: getColors(context)
                                      .onBackground
                                      .withOpacity(.2),
                                  width: wXD(1, context),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Modular.to.pushNamed(
                                        "/product/report-product",
                                        arguments: model.id),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Denunciar',
                                        style: textFamily(
                                          context,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              DefaultAppBar('Detalhes')
            ],
          ),
        ),
      ),
    );
  }
}

class ProductInformations extends StatelessWidget {
  // final MainStore mainStore = Modular.get();
  final CartStore store = Modular.get();
  final Ads adsModel;

  ProductInformations({Key? key, required this.adsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: getColors(context).onBackground.withOpacity(.2))),
      ),
      padding: EdgeInsets.symmetric(
        vertical: wXD(27, context),
        horizontal: wXD(24, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getAdditionalInformations(adsModel.id, adsModel.sellerId),
        builder: (context, snapshotFutureDoc) {
          if(!snapshotFutureDoc.hasData){
            return LinearProgressIndicator();
          }
          List<Map<String, dynamic>> additionalList = snapshotFutureDoc.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informações adicionais:',
                style: textFamily(
                  context,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: getColors(context).onBackground,
                ),
              ),
              Column(
                children: additionalList.map((Map<String, dynamic> additionalMap) {
                  DocumentSnapshot additionalDoc = additionalMap['doc']!;
                  Map response = additionalMap['response']!;

                  switch (additionalDoc['type']) {
                    case "text-field":
                      return TextFieldConstructor(
                        additionalModel: AdditionalModel.fromDoc(additionalDoc),
                        responseText: response['text'],
                      );
      
                    case "text-area":
                      return TextAreaConstructor(
                        model: AdditionalModel.fromDoc(additionalDoc),
                        responseText: response['text'],
                      );
      
                    case "increment":
                      return IncrementFieldConstructor(
                        model: AdditionalModel.fromDoc(additionalDoc),
                        responseCount: response['count'],
                        responseValue: response['value'],
                      );
      
                    case "text":
                      return TextScore(
                        model: AdditionalModel.fromDoc(additionalDoc),
                      );
      
                    case "check-box":
                      return CheckBoxArrayConstructor(
                        model: AdditionalModel.fromDoc(additionalDoc),
                        sellerId: adsModel.sellerId,
                        responseMap: response,
                      );
      
                    case "radio-button":
                      return RadioButtonConstructor(
                        additionalModel: AdditionalModel.fromDoc(additionalDoc),
                        sellerId: adsModel.sellerId,
                        responseLabel: response['label'],
                      );
      
                    case "combo-box":
                      return DropdownArrayConstructor(
                        model: AdditionalModel.fromDoc(additionalDoc),
                        sellerId: adsModel.sellerId,
                        responseLabel: response['label'],
                      );
      
                    default:
                      return Container();
                  }
                }).toList(),
              ),
            ],
          );
        }
      ),
    );
  }
}

// class AddToCart extends StatelessWidget {
//   final MainStore mainStore = Modular.get();
//   final ProductStore store = Modular.get();
//   final Ads adsModel;
//   final _formKey = GlobalKey<FormState>();

//   AddToCart({Key? key, required this.adsModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: wXD(27, context),
//         left: wXD(24, context),
//         right: wXD(24, context),
//       ),
//       child: FutureBuilder<List<DocumentSnapshot>>(
//         future: store.getAdditionalList(adsModel.id, adsModel.sellerId),
//         builder: (context, snapshotFutureDoc) {
//           if(!snapshotFutureDoc.hasData){
//             return LinearProgressIndicator();
//           }
//           List<DocumentSnapshot> additionalList = snapshotFutureDoc.data!;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Adicionar ao carrinho:',
//                 style: textFamily(
//                   context,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w600,
//                   color: getColors(context).onBackground,
//                 ),
//               ),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: additionalList.map((DocumentSnapshot additionalDoc) {
//                     switch (additionalDoc['type']) {
//                       case "text-field":
//                         return TextFieldScore(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                         );
                
//                       case "text-area":
//                         return TextArea(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                         );
                
//                       case "increment":
//                         return IncrementField(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                         );
                
//                       case "text":
//                         return TextScore(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                         );
                
//                       case "check-box":
//                         return CheckBoxArray(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                           sellerId: adsModel.sellerId,
//                         );
                
//                       case "radio-button":
//                         return RadioButtonArray(
//                           additionalModel: AdditionalModel.fromDoc(additionalDoc),
//                           sellerId: adsModel.sellerId,
//                         );
                
//                       case "combo-box":
//                         return DropdownArray(
//                           model: AdditionalModel.fromDoc(additionalDoc),
//                           sellerId: adsModel.sellerId,
//                         );
                
//                       default:
//                         return Container();
//                     }
//                   }).toList(),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(
//                     top: wXD(32, context),
//                     bottom: wXD(23, context)),
//                 width: maxWidth(context),
//                 alignment: Alignment.centerRight,
//                 child: SideButton(
//                   height: wXD(56, context),
//                   width: wXD(208, context),
//                   title: 'Adicionar ao carrinho',
//                   fontSize: 16,
//                   onTap: () async {
//                     print('store.product: ${store.product}');
//                     if(_formKey.currentState!.validate()){
//                       if (!(await mainStore.addItemToCart(adsModel.id, store.product, context))) {
//                         print('success');
//                         // mainStore.setPage(1);
//                         Modular.to.pop();
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ],
//           );
//         }
//       ),
//     );
//   }
// }