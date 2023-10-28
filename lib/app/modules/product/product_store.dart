import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mobx/mobx.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStoreBase with _$ProductStore;

abstract class _ProductStoreBase with Store {
  final MainStore mainStore = Modular.get();
  @observable
  String reportReason = '';
  @observable
  int imageIndex = 1;
  @observable
  bool canBack = true;
  @observable
  PageController reportPageController = PageController();
  @observable
  ObservableList<DocumentSnapshot> ratings = <DocumentSnapshot>[].asObservable();
  // @observable
  // List additionalResponse = [];
  @observable
  Map<String, Map> product = {};

  @action
  Future<List<Map<String, dynamic>>> getDropdownList(String additionalId, String sellerId) async{    
    List<Map<String, dynamic>> dropdownArray = [];
    QuerySnapshot dropdownList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("dropdown")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    for (DocumentSnapshot dropdownDoc in dropdownList.docs) {
      try {
        dropdownArray[dropdownDoc['index']] = {
          "index": dropdownDoc['index'],
          "label": dropdownDoc['label'],
          "value": dropdownDoc['value'],
        };
        
      } catch (e) {
        dropdownArray.add({
          "index": dropdownDoc['index'],
          "label": dropdownDoc['label'],
          "value": dropdownDoc['value'],
        });
      }
    }
    return dropdownArray;
  }

  @action
  Future<List<Map<String, dynamic>>> getRadiobuttonList(String additionalId, String sellerId) async{    
    List<Map<String, dynamic>> radiobuttonArray = [];
    QuerySnapshot radiobuttonList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("radiobutton")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    for (DocumentSnapshot radiobuttonDoc in radiobuttonList.docs) {
      try {
        radiobuttonArray[radiobuttonDoc['index']] = {
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
        };
        
      } catch (e) {
        radiobuttonArray.add({
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
        });
      }
    }
    return radiobuttonArray;
  }

  @action
  Future<List<Map<String, dynamic>>> getCheckboxList(String additionalId, String sellerId) async{
    List<Map<String, dynamic>> checkboxArray = [];
    QuerySnapshot checkboxList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("checkbox")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    for (DocumentSnapshot checkboxDoc in checkboxList.docs) {
      // print('checkboxDoc: ${checkboxDoc.data()}');

      try {
        checkboxArray[checkboxDoc['index']] = {
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
        };
        // print('success');
        
      } catch (e) {
        // print('failed');
        // print(e);
        checkboxArray.add({
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
        });
      }
    }
    return checkboxArray;
  }

  @action
  Future<Map<String, dynamic>> getAdditionalList(String adsId, String sellerId) async{
    QuerySnapshot additionalQuery = await FirebaseFirestore.instance.collection('ads').doc(adsId).collection('additional').orderBy('index').get();
    print('additionalQuery.docs: ${additionalQuery.docs.length}');
    List<DocumentSnapshot> customerAdditionalList = [];
    List<Map<String, dynamic>> sellerAdditionalList = [];

    for (var i = 0; i < additionalQuery.docs.length; i++) {
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance.collection('sellers').doc(sellerId).collection('additional').doc(additionalQuery.docs[i].id).get();
      print('additionalDoc.id: ${additionalDoc.id}');
      if(additionalDoc['customer_config'] == "edition"){        
        switch (additionalDoc['type']) {
          case "check-box":
            QuerySnapshot checkboxQuery = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
              .collection('additional')
              .doc(additionalDoc.id)
              .collection("checkbox")
              .where("status", isEqualTo: "ACTIVE")
              .orderBy("index")
              .get();

            Map<String, dynamic> checkedMap = {};

            for (DocumentSnapshot checkboxDoc in checkboxQuery.docs) {              
              checkedMap.putIfAbsent(checkboxDoc.id, () => {
                "response": false,
                "value": checkboxDoc['value'],
              });
            }

            product.putIfAbsent(additionalDoc.id, () => {
              "additional_type": "check-box",                                  
              "checked_map": checkedMap,
            });
            break;

          case "radio-button":
            QuerySnapshot radiobuttonQuery = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
              .collection('additional')
              .doc(additionalDoc.id)
              .collection("radiobutton")
              .where("status", isEqualTo: "ACTIVE")
              .orderBy("index")
              .get();

            DocumentSnapshot radiobuttonDoc = radiobuttonQuery.docs[0];

            product.putIfAbsent(additionalDoc.id, () => {
              "additional_type": "radio-button",
              "response_index": 0,
              "response_label": radiobuttonDoc['label'],
              "response_value": radiobuttonDoc['value'],
            });
            break;

          case "combo-box":
            QuerySnapshot dropdownQuery = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
              .collection('additional')
              .doc(additionalDoc.id)
              .collection("dropdown")
              .where("status", isEqualTo: "ACTIVE")
              .orderBy("index")
              .get();

            DocumentSnapshot dropdownDoc = dropdownQuery.docs[0];

            product.putIfAbsent(additionalDoc.id, () => {
              "additional_type": "combo-box",
              "response_label": dropdownDoc['label'],
              "response_index": dropdownDoc['index'],
              "response_value": dropdownDoc['value'],
            });
            break;

          case "text-field":
            product.putIfAbsent(additionalDoc.id, () => {
              "response_text": "",
              "additional_type": "text",
            });
            break;

          case "text-area":
            product.putIfAbsent(additionalDoc.id, () => {
              "response_text": "",
              "additional_type": "text",
            });
            break;

          case "increment":
            product.putIfAbsent(additionalDoc.id, () => {
              "additional_type": "increment",
              "response_count": additionalDoc.get("increment_minimum"),
              "response_value": additionalDoc.get("increment_value") * additionalDoc.get("increment_minimum"),
            });
            break;

          default:
        }
        customerAdditionalList.add(additionalDoc);
      } else {
        DocumentSnapshot additionalResponseDoc = additionalQuery.docs[i];
        Map<String, dynamic> response = {};
        print("additionalDoc['type']: ${additionalDoc['type']}");

        switch (additionalDoc['type']) {
          case "check-box":
            QuerySnapshot checkboxResponseQuery = await additionalResponseDoc.reference.collection('checkbox').get();
            Map<String, bool> checkboxResponse = {};
            for (var i = 0; i < checkboxResponseQuery.docs.length; i++) {
              DocumentSnapshot checkboxDoc = checkboxResponseQuery.docs[i];
              checkboxResponse.putIfAbsent(checkboxDoc['id'], () => checkboxDoc['response']);
            }

            response = checkboxResponse;
            break;

          case "radio-button":
            response = {"label": additionalResponseDoc['response_label']};
            break;

          case "combo-box":
            response = {"label": additionalResponseDoc['response_label']};
            break;

          case "text-field":
            response = {"text": additionalResponseDoc['response_text']};
            break;

          case "text-area":
            response = {"text": additionalResponseDoc['response_text']};
            break;

          case "increment":
            response = {
              "count": additionalResponseDoc['response_count'],
              "value": additionalResponseDoc['response_value'],
            };
            break;

          default:
        }
        print('response: $response');
        sellerAdditionalList.add({
          "doc": additionalDoc,
          "response": response,
        });     
      }
    }
    return {
      "customer-additional": customerAdditionalList,
      "seller-additional": sellerAdditionalList,
    };
  }

  @action
  void setImageIndex(_imageIndex) => imageIndex = _imageIndex;

  @action
  Future<Map<String, num>> getAverageEvaluation(String adsId) async {
    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsId)
        .collection('ratings')
        .where("status", isEqualTo: "VISIBLE")
        .get();

    num average = 0;
    // print("r atingsQuery.docs.isNotEmpty: ${ratingsQuery.docs.isNotEmpty}");
    if (ratingsQuery.docs.isNotEmpty) {
      for (var i = 0; i < ratingsQuery.docs.length; i++) {
        DocumentSnapshot ratingDoc = ratingsQuery.docs[i];
        average += ratingDoc['rating'];
      }
      average = average / ratingsQuery.docs.length;
    }
    // print("average: $average");
    return {
      "average-rating": average,
      "length-rating": ratingsQuery.docs.length,
    };
  }

  void getRatings(int ratingView, List<DocumentSnapshot> ratingDocs) {
    if (ratingView == 0) {
      ratings = ratingDocs.asObservable();
    } else {
      List<DocumentSnapshot> opnionsDocs = [];
      for (DocumentSnapshot ratingDoc in ratingDocs) {
        print("product_ratings: ${ratingDoc["rating"]} ");
        if (ratingView == 1 && ratingDoc["rating"] >= 3) {
          opnionsDocs.add(ratingDoc);
        } else if (ratingView == 2 && ratingDoc["rating"] < 3) {
          opnionsDocs.add(ratingDoc);
        }
      }
      ratings = opnionsDocs.asObservable();
    }
  }

  @action
  Future likeAds(String adsId, bool value) async {
    User _user = FirebaseAuth.instance.currentUser!;
    await cloudFunction(function: "likeAds", object: {
      "like": value,
      "adsId": adsId,
      "userId": _user.uid,
    });
  }

  Future<bool> toAsk(String? question, String adsId, context) async {
    User _user = FirebaseAuth.instance.currentUser!;
    OverlayEntry loadOverlay;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    if (question == null || question == '') {
      loadOverlay.remove();
      showToast("Escreva uma pergunta antes de enviar");
      return false;
    }

    await cloudFunction(function: "toAsk", object: {
      "question": question,
      "adsId": adsId,
      "userId": _user.uid,
    }).then((value) => showToast("Pergunta enviada com sucesso!"));
    canBack = true;

    loadOverlay.remove();
    return true;
  }

  Future reportProduct(String justify, String adsId, context) async {
    OverlayEntry loadOverlay;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    User _user = FirebaseAuth.instance.currentUser!;
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    await FirebaseFirestore.instance.collection("reporteds").add({
      "created_at": FieldValue.serverTimestamp(),
      "collection": "ads",
      "justify": justify,
      "reason": reportReason,
      "reported": adsId,
      "user_id": _user.uid,
    }).then((value) => value.update({"id": value.id}));

    showToast("Anúncio reportado com sucesso");

    canBack = true;
    loadOverlay.remove();

    reportReason = '';
    Modular.to.pop();
  }

  @action
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Se liga!!',
        text: 'Se liga nesse aplicativo Mercado Expresso',
        linkUrl: 'https://mercadoexpresso.com.br/',
        chooserTitle: 'Compartilhar usando');
  }
}
