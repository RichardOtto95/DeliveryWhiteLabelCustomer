import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/product/product_store.dart';
import 'package:delivery_customer/app/modules/product/widgets/characteristics.dart';
import 'package:delivery_customer/app/modules/product/widgets/check_box_array.dart';
import 'package:delivery_customer/app/modules/product/widgets/combo_box_array.dart';
import 'package:delivery_customer/app/modules/product/widgets/increment_field.dart';
import 'package:delivery_customer/app/modules/product/widgets/radio_button_array.dart';
import 'package:delivery_customer/app/modules/product/widgets/store_informations.dart';
import 'package:delivery_customer/app/modules/product/widgets/text_area.dart';
import 'package:delivery_customer/app/modules/product/widgets/text_field.dart';
import 'package:delivery_customer/app/shared/additional_models/text_area.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../../shared/additional_models/check_box.dart';
import '../../shared/additional_models/combo_box.dart';
import '../../shared/additional_models/increment_field.dart';
import '../../shared/additional_models/radio_button.dart';
import '../../shared/additional_models/text_field_score.dart';
import '../../shared/additional_models/text_score.dart';
import '../../shared/color_theme.dart';
import 'widgets/item_data.dart';
import 'widgets/opinions.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();

  @override
  void dispose() {
    store.imageIndex = 1;
    // store.product.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mainStore.loadOverlay != null) {
          return !mainStore.loadOverlay!.mounted;
        } else {
          return store.canBack;
        }
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ads')
                    .doc(mainStore.adsId)
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
                          StoreInformations(
                            sellerId: model.sellerId,
                            adsId: model.id,
                          ),
                          GetFutureAdditionalList(adsModel: model),
                          Opinions(model: model),
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

class GetFutureAdditionalList extends StatelessWidget {
  final Ads adsModel;

  GetFutureAdditionalList({
    Key? key, 
    required this.adsModel,
  }) : super(key: key);

  final ProductStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: store.getAdditionalList(adsModel.id, adsModel.sellerId),
      builder: (context, snapshot) {
        print("snapshot.hasError: ${snapshot.error}");
        if(!snapshot.hasData){
          return LinearProgressIndicator();
        }
        List<Map<String, dynamic>> sellerAdditionalList = snapshot.data!['seller-additional'];
        List<DocumentSnapshot> customerAdditionalList = snapshot.data!['customer-additional'];
        return Column(
          children: [
            ProductInformations(
              adsModel: adsModel,
              sellerAdditionalList: sellerAdditionalList,
            ),
            AddToCart(
              adsModel: adsModel,
              customerAdditionalList: customerAdditionalList,
            ),
          ],
        );
      }
    );
  }

}

class ProductInformations extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();
  final Ads adsModel;
  final List<Map<String, dynamic>> sellerAdditionalList;


  ProductInformations({
    Key? key, 
    required this.adsModel, 
    required this.sellerAdditionalList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sellerAdditionalList.isEmpty ? Container() :
    Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: getColors(context).onBackground.withOpacity(.2),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: wXD(27, context),
        horizontal: wXD(24, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Text(
              'Informações adicionais:',
              style: textFamily(
                context,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Column(
            children: sellerAdditionalList.map((Map<String, dynamic> additionalMap) {
              DocumentSnapshot additionalDoc = additionalMap['doc']!;
              Map<String, dynamic> response = additionalMap['response']!;
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
      ),
    );
  }
}

class AddToCart extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();
  final Ads adsModel;
  final List<DocumentSnapshot> customerAdditionalList;
  final _formKey = GlobalKey<FormState>();

  AddToCart({
    Key? key, 
    required this.adsModel, 
    required this.customerAdditionalList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: wXD(27, context),
        left: wXD(24, context),
        right: wXD(24, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adicionar ao carrinho:',
            style: textFamily(
              context,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: getColors(context).onBackground,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: customerAdditionalList.map((DocumentSnapshot additionalDoc) {
                switch (additionalDoc['type']) {
                  case "text-field":
                    return TextFieldScore(
                      model: AdditionalModel.fromDoc(additionalDoc),
                    );
            
                  case "text-area":
                    return TextArea(
                      model: AdditionalModel.fromDoc(additionalDoc),
                    );
            
                  case "increment":
                    return IncrementField(
                      model: AdditionalModel.fromDoc(additionalDoc),
                    );
            
                  case "text":
                    return TextScore(
                      model: AdditionalModel.fromDoc(additionalDoc),
                    );
            
                  case "check-box":
                    return CheckBoxArray(
                      model: AdditionalModel.fromDoc(additionalDoc),
                      sellerId: adsModel.sellerId,
                    );
            
                  case "radio-button":
                    return RadioButtonArray(
                      additionalModel: AdditionalModel.fromDoc(additionalDoc),
                      sellerId: adsModel.sellerId,
                    );
            
                  case "combo-box":
                    return DropdownArray(
                      model: AdditionalModel.fromDoc(additionalDoc),
                      sellerId: adsModel.sellerId,
                    );
            
                  default:
                    return Container();
                }
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: wXD(32, context),
                bottom: wXD(23, context)),
            width: maxWidth(context),
            alignment: Alignment.centerRight,
            child: SideButton(
              height: wXD(56, context),
              width: wXD(208, context),
              title: 'Adicionar ao carrinho',
              fontSize: 16,
              onTap: () async {
                if(_formKey.currentState!.validate()){
                  if (!(await mainStore.addItemToCart(adsModel.id, store.product, context))) {
                    // mainStore.setPage(1);
                    Modular.to.pop();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}