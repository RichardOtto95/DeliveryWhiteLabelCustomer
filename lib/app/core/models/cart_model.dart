// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

class CartModel {
  final String adsId;
  int amount;
  final num unitPrice;
  num totalPrice;
  // final num rating;
  // final bool rated;
  final String sellerId;
  final Map additionalMap;

  CartModel({
    required this.adsId,
    required this.sellerId,
    required this.amount,
    required this.totalPrice,
    required this.unitPrice,
    // required this.rating,
    // required this.rated,
    required this.additionalMap,
  });

  Map<String, dynamic> toJson() => {
    'ads_id': adsId,
    'amount': amount,
    'total_price': totalPrice,
    'unit_price': unitPrice,
    // 'rating': rating,
    // 'rated': rated,
    'seller_id': sellerId,
    'additional_map': additionalMap,
  };

  ObservableMap<String, dynamic> toObservableMap(CartModel model) => {
    'ads_id': model.adsId,
    'amount': model.amount,
    'total_price': model.totalPrice,
    'unit_price': model.unitPrice,
    // 'rating': model.rating,
    // 'rated': model.rated,
    'seller_id': model.sellerId,
    'additional_map': model.additionalMap,
  }.asObservable();
}
