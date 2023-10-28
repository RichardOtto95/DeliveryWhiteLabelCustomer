import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

class AdditionalModel {
  final dynamic createdAt;
  final String id;
  final String status;
  final String type;
  final String title;
  final String? hint;
  final bool notEdit;
  final bool? mandatory;
  final num? incrementValue;
  final num? incrementMinimum;
  final num? incrementMaximum;
  final num? numberMandatoryFields;
  final bool? short;
  final String? sellerConfig;
  final String? customerConfig;
  final bool? autoSelected;
  final String alignment;
  final num fontSize;


  AdditionalModel({
    this.createdAt,
    required this.id,
    required this.status,
    required this.title,
    required this.type,
    required this.notEdit,
    required this.mandatory,
    required this.hint,
    required this.incrementValue,
    required this.incrementMinimum,
    required this.incrementMaximum,
    required this.numberMandatoryFields,
    required this.short,
    required this.sellerConfig,
    required this.customerConfig,
    required this.alignment,
    required this.autoSelected,
    required this.fontSize,
  });

  factory AdditionalModel.fromDoc(DocumentSnapshot doc) {
    AdditionalModel model = AdditionalModel(
      id: doc.get("id"),
      status: doc.get("status"),
      createdAt: doc.get("created_at"),
      title: doc.get("title"),
      type: doc.get("type"),
      notEdit: doc.get("not_edit"),
      mandatory: doc.get("mandatory"),
      hint: doc.get("hint"),
      incrementValue: doc.get("increment_value"),
      incrementMinimum: doc.get("increment_minimum"),
      incrementMaximum: doc.get("increment_maximum"),
      numberMandatoryFields: doc.get("number_mandatory_fields"),
      short: doc.get("short"),
      sellerConfig: doc.get("seller_config"),
      customerConfig: doc.get("customer_config"),
      alignment: doc.get("alignment"),
      autoSelected: doc.get("auto_selected"),
      fontSize: doc.get("font_size"),
    );

    // try {
    //   model.sellerConfig = doc['seller_config'];
    //   model.customerConfig = doc['customer_config'];
    // } catch (e) {
    //   User _user = FirebaseAuth.instance.currentUser!;
    //   FirebaseFirestore.instance.collection('sellers').doc(_user.uid).collection('additional').doc(doc.id).update({
    //     "seller_config": "reading",
    //     "customer_config": "edition",
    //   });
    // }

    return model;
  }

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "status": this.status,
    "created_at": this.createdAt,
    "title": this.title,
    "type": this.type,
    "not_edit": this.notEdit,
    "mandatory": this.mandatory,
    "hint": this.hint,
    "increment_value": this.incrementValue,
    "increment_minimum": this.incrementMinimum,
    "increment_maximum": this.incrementMaximum,
    "number_mandatory_fields": this.numberMandatoryFields,
    "short": this.short,
    "seller_config": this.sellerConfig,
    "customer_config": this.customerConfig,
    "auto_selected": this.autoSelected,
    "alignment": this.alignment,
    "font_size": this.fontSize,
  };

  ObservableMap<String, dynamic> toJsonAsObservable() => {
    "id": this.id,
    "status": this.status,
    "created_at": this.createdAt,
    "title": this.title,
    "type": this.type,
    "not_edit": this.notEdit,
    "mandatory": this.mandatory,
    "hint": this.hint,
    "increment_value": this.incrementValue,
    "increment_minimum": this.incrementMinimum,
    "increment_maximum": this.incrementMaximum,
    "number_mandatory_fields": this.numberMandatoryFields,
    "short": this.short,
    "seller_config": this.sellerConfig,
    "customer_config": this.customerConfig,
    "auto_selected": this.autoSelected,
    "alignment": this.alignment,
    "font_size": this.fontSize,
  }.asObservable();
}
