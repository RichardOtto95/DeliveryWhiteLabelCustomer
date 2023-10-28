import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class TransactionModel {
  final Timestamp? createdAt;
  final String? customerId;
  final String? id;
  final String? orderId;
  final String? paymentIntent;
  final String? paymentMethod;
  final String? sellerId;
  final Timestamp? updatedAt;
  final num? value;
  final String? status;

  TransactionModel({
    this.createdAt,
    this.id,
    this.customerId,
    this.orderId,
    this.paymentIntent,
    this.sellerId,
    this.updatedAt,
    this.value,
    this.paymentMethod,
    this.status,
  });

  factory TransactionModel.fromDoc(DocumentSnapshot doc) {
    return TransactionModel(
      createdAt: doc['created_at'],
      id: doc['id'],
      customerId: doc['customer_id'],
      orderId: doc['order_id'],
      paymentIntent: doc['payment_intent'],
      sellerId: doc['seller_id'],
      updatedAt: doc['updated_at'],
      value: doc['value'],
      paymentMethod: doc['payment_method'],
      status: doc['status'],
    );
  }

  Map<String, dynamic> toJson(TransactionModel model) => {
        'created_at': model.createdAt,
        'id': model.id,
        'customer_id': model.customerId,
        'order_id': model.orderId,
        'payment_intent': model.paymentIntent,
        'seller_id': model.sellerId,
        'updated_at': model.updatedAt,
        'value': model.value,
        'payment_method': model.paymentMethod,
        'status': model.status,
      };

  ObservableMap<String, dynamic> toObservableMap(TransactionModel model) => {
        'created_at': model.createdAt,
        'id': model.id,
        'customer_id': model.customerId,
        'order_id': model.orderId,
        'payment_intent': model.paymentIntent,
        'seller_id': model.sellerId,
        'updated_at': model.updatedAt,
        'value': model.value,
        'payment_method': model.paymentMethod,
        'status': model.status,
      }.asObservable();
}
