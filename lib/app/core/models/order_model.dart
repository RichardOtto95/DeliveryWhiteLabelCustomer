import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order {
  int? totalAmount;
  num? priceRateDelivery;
  num? priceTotal;
  num? priceTotalWithDiscount;
  // double? rating;
  String? status;
  String? agentToken;
  String? customerToken;
  String? id;
  String? customerId;
  String? sellerId;
  String? agentId;
  String? agentStatus;
  String? discontinuedBy;
  String? userIdDiscontinued;
  String? discontinuedReason;
  String? customerAddressId;
  String? sellerAddressId;
  bool rated;
  Timestamp? createdAt;
  Timestamp? startDate;
  Timestamp? endDate;
  Timestamp? sendDate;
  String? couponId;
  num? change;
  String? paymentMethod;
  Map<String, dynamic>? sellerAddress;
  Map<String, dynamic>? customerAddress;
  String? customerFormatedAddress;
  String? storeName;

  Order({
    this.agentStatus,
    this.agentId,
    this.id,
    this.customerId,
    this.sellerId,
    this.discontinuedBy,
    this.discontinuedReason,
    this.userIdDiscontinued,
    // this.rating,
    this.startDate,
    this.endDate,
    this.priceRateDelivery,
    this.totalAmount,
    this.rated = false,
    this.status,
    this.priceTotal,
    this.agentToken,
    this.customerToken,
    this.createdAt,
    this.sendDate,
    this.customerAddressId,
    this.sellerAddressId,
    this.couponId,
    this.priceTotalWithDiscount,
    this.change,
    this.paymentMethod,
    this.sellerAddress,
    this.customerAddress,
    this.customerFormatedAddress,
    this.storeName,
  });

  factory Order.fromDoc(DocumentSnapshot doc) {
    // Order order = Order();
    // String field = "";
    // try {
    //   field = "id";
    //   order.id = doc['id'];
    //   field = "customer_id";
    //   order.customerId = doc['customer_id'];
    //   field = "seller_id";
    //   order.sellerId = doc['seller_id'];
    //   field = "discontinued_by";
    //   order.discontinuedBy = doc['discontinued_by'];
    //   field = "discontinued_reason";
    //   order.discontinuedReason = doc['discontinued_reason'];
    //   field = "user_id_discontinued";
    //   order.userIdDiscontinued = doc['user_id_discontinued'];
    //   field = "start_date";
    //   order.startDate = doc['start_date'];
    //   field = "end_date";
    //   order.endDate = doc['end_date'];
    //   field = "price_rate_delivery";
    //   order.priceRateDelivery = doc['price_rate_delivery'];
    //   field = "total_amount";
    //   order.totalAmount = doc['total_amount'];
    //   field = "price_total";
    //   order.priceTotal = doc['price_total'];
    //   field = "rated";
    //   order.rated = doc['rated'];
    //   field = "status";
    //   order.status = doc['status'];
    //   field = "customer_token";
    //   order.customerToken = doc['customer_token'];
    //   field = "agent_token";
    //   order.agentToken = doc['agent_token'];
    //   field = "customer_address_id";
    //   order.customerAdderessId = doc['customer_address_id'];
    //   field = "created_at";
    //   order.createdAt = doc['created_at'];
    //   field = "send_date";
    //   order.sendDate = doc['send_date'];
    //   field = "agent_id";
    //   order.agentId = doc['agent_id'];
    //   field = "agent_status";
    //   order.agentStatus = doc['agent_status'];
    //   field = "coupon_id";
    //   order.couponId = doc['coupon_id'];
    //   field = "price_total_with_discount";
    //   order.priceTotalWithDiscount = doc['price_total_with_discount'];
    //   field = "change";
    //   order.change = doc['change'];
    //   field = "payment_method";
    //   order.paymentMethod = doc['payment_method'];
    //   field = "seller_address";
    //   order.sellerAddress = doc['seller_address'];
    //   field = "customer_address";
    //   order.customerAddress = doc['customer_address'];
    //   field = "customer_formated_address";
    //   order.customerFormatedAddress = doc['customer_formated_address'];
    //   field = "store_name";
    //   order.storeName = doc['store_name'];
    //   return order;
    // } catch (e) {
    //   print(e);
    // }    
    // print('field: $field');
    // return order;
    return Order(
      id: doc['id'],
      customerId: doc['customer_id'],
      sellerId: doc['seller_id'],
      discontinuedBy: doc['discontinued_by'],
      discontinuedReason: doc['discontinued_reason'],
      userIdDiscontinued: doc['user_id_discontinued'],
      startDate: doc['start_date'],
      endDate: doc['end_date'],
      priceRateDelivery: doc['price_rate_delivery'],
      totalAmount: doc['total_amount'],
      priceTotal: doc['price_total'],
      rated: doc['rated'],
      status: doc['status'],
      customerToken: doc['customer_token'],
      agentToken: doc['agent_token'],
      customerAddressId: doc['customer_address_id'],
      sellerAddressId: doc['seller_address_id'],
      createdAt: doc['created_at'],
      sendDate: doc['send_date'],
      agentId: doc["agent_id"],
      agentStatus: doc["agent_status"],
      couponId: doc["coupon_id"],
      priceTotalWithDiscount: doc['price_total_with_discount'],
      change: doc['change'],
      paymentMethod: doc['payment_method'],
      sellerAddress: doc['seller_address'],
      customerAddress: doc['customer_address'],
      customerFormatedAddress: doc['customer_formated_address'],
      storeName: doc['store_name'],
    );
  }

  Map<String, dynamic> toJson({Order? order}) => order == null
      ? {
          'id': id,
          'customer_id': customerId,
          'seller_id': sellerId,
          'discontinued_by': discontinuedBy,
          'discontinued_reason': discontinuedReason,
          'start_date': startDate,
          'end_date': endDate,
          'price_rate_delivery': priceRateDelivery,
          'total_amount': totalAmount,
          'rated': rated,
          'status': status,
          'customer_token': customerToken,
          'agent_token': agentToken,
          'created_at': createdAt,
          'price_total': priceTotal,
          'price_total_with_discount': priceTotalWithDiscount,
          'user_id_discontinued': userIdDiscontinued,
          'send_date': sendDate,
          // 'rating': rating,
          'agent_id': agentId,
          'agent_status': agentStatus,
          'customer_address_id': customerAddressId,
          'seller_address_id': sellerAddressId,
          'coupon_id': couponId,
          'change': change,
          'payment_method': paymentMethod,
          'seller_address': sellerAddress,
          'customer_address': customerAddress,
          'customer_formated_address': customerFormatedAddress,
          'store_name': storeName,
        }
      : {
          'id': order.id,
          'customer_id': order.customerId,
          'seller_id': order.sellerId,
          'discontinued_by': order.discontinuedBy,
          'discontinued_reason': order.discontinuedReason,
          'start_date': order.startDate,
          'end_date': order.endDate,
          'price_rate_delivery': order.priceRateDelivery,
          'total_amount': order.totalAmount,
          'rated': order.rated,
          'status': order.status,
          'customer_token': order.customerToken,
          'agent_token': order.agentToken,
          'created_at': order.createdAt,
          'price_total': order.priceTotal,
          'price_total_with_discount': order.priceTotalWithDiscount,
          'user_id_discontinued': order.userIdDiscontinued,
          'send_date': order.sendDate,
          // 'rating': order.rating,
          'agent_id': order.agentId,
          'agent_status': order.agentStatus,
          'customer_address_id': order.customerAddressId,
          'seller_address_id': order.sellerAddressId,
          'coupon_id': order.couponId,
          'change': order.change,
          'payment_method': order.paymentMethod,
          'seller_address': order.sellerAddress,
          'customer_address': order.customerAddress,
          'customer_formated_address': order.customerFormatedAddress,
          'store_name': order.storeName,
        };

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getAds() async {    
    QuerySnapshot<Map<String, dynamic>> orderAds = await FirebaseFirestore
        .instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(id)
        .collection("ads")
        .get();

    print('getAds: $id - ${orderAds.docs.length}');
    return orderAds.docs;
  }
}
