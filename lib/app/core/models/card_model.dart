import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class CardModel {
  final String billingAddress;
  final String billingCep;
  final String billingCity;
  final String billingState;
  final String cardId;
  final List colors;
  final Timestamp createdAt;
  final String dueDate;
  final String finalNumber;
  final String id;
  final bool main;
  final String nameCardHolder;
  final String status;
  final String brand;

  CardModel({
    required this.billingAddress,
    required this.billingCep,
    required this.billingCity,
    required this.billingState,
    required this.cardId,
    required this.colors,
    required this.createdAt,
    required this.dueDate,
    required this.finalNumber,
    required this.id,
    required this.main,
    required this.nameCardHolder,
    required this.status,
    required this.brand,
  });

  factory CardModel.fromDoc(DocumentSnapshot doc) {
    return CardModel(
      billingAddress: doc['billing_address'],
      billingCep: doc['billing_cep'],
      billingCity: doc['billing_city'],
      billingState: doc['billing_state'],
      cardId: doc['card_id'],
      colors: doc['colors'],
      createdAt: doc['created_at'],
      dueDate: doc['due_date'],
      finalNumber: doc['final_number'],
      id: doc['id'],
      main: doc['main'],
      nameCardHolder: doc['name_card_holder'],
      status: doc['status'],
      brand: doc['brand'],
    );
  }

  Map<String, dynamic> toJson(CardModel model) => {
        'billing_address': model.billingAddress,
        'billing_cep': model.billingCep,
        'billing_city': model.billingCity,
        'billing_state': model.billingState,
        'card_id': model.cardId,
        'colors': model.colors,
        'created_at': model.createdAt,
        'due_date': model.dueDate,
        'final_number': model.finalNumber,
        'id': model.id,
        'main': model.main,
        'name_card_holder': model.nameCardHolder,
        'status': model.status,
        'brand': model.brand,
      };

  ObservableMap<String, dynamic> toObservableMap(CardModel model) => {
        'billing_address': model.billingAddress,
        'billing_cep': model.billingCep,
        'billing_city': model.billingCity,
        'billing_state': model.billingState,
        'card_id': model.cardId,
        'colors': model.colors,
        'created_at': model.createdAt,
        'due_date': model.dueDate,
        'final_number': model.finalNumber,
        'id': model.id,
        'main': model.main,
        'name_card_holder': model.nameCardHolder,
        'status': model.status,
        'brand': model.brand,
      }.asObservable();
}
