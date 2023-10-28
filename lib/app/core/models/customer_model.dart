import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String? avatar;
  String? fullname;
  String? username;
  Timestamp? birthday;
  String? cpf;
  String? rg;
  String? gender;
  String? id;
  String? phone;
  String? status;
  String? country;
  String? mainAddress;
  String? customerId;
  Timestamp? createdAt;
  int? newNotifications;
  int? newMessages;
  int? newSupportMessages;
  List<dynamic>? tokenId;
  bool? connected;
  bool? notificationEnabled;
  String? email;
  String? userPromotionalCode;
  bool? wasInvited;
  num? accountBalance;

  Customer({
    this.createdAt,
    this.avatar,
    this.fullname,
    this.username,
    this.birthday,
    this.cpf,
    this.rg,
    this.gender,
    this.id,
    this.phone,
    this.status,
    this.newNotifications,
    this.tokenId,
    this.connected,
    this.notificationEnabled,
    this.country,
    this.mainAddress,
    this.email,
    this.userPromotionalCode,
    this.wasInvited,
    this.customerId,
    this.accountBalance,
    this.newMessages,
    this.newSupportMessages,
  });

  factory Customer.fromDoc(DocumentSnapshot doc) {
    return Customer(
      createdAt: doc['created_at'],
      avatar: doc['avatar'],
      fullname: doc['fullname'],
      username: doc['username'],
      birthday: doc['birthday'],
      cpf: doc['cpf'],
      rg: doc['rg'],
      gender: doc['gender'],
      id: doc['id'],
      phone: doc['phone'],
      status: doc['status'],
      newNotifications: doc['new_notifications'],
      newMessages: doc['new_messages'],
      newSupportMessages: doc['new_support_messages'],
      tokenId: doc['token_id'],
      connected: doc['connected'],
      country: doc['country'],
      notificationEnabled: doc['notification_enabled'],
      mainAddress: doc['main_address'],
      email: doc['email'],
      userPromotionalCode: doc['user_promotional_code'],
      wasInvited: doc['was_invited'],
      customerId: doc['customer_id'],
      accountBalance: doc['account_balance'],
    );
  }

  Map<String, dynamic> toJson({Customer? model}) => {
        'created_at': model == null ? createdAt : model.createdAt,
        'avatar': model == null ? avatar : model.avatar,
        'fullname': model == null ? fullname : model.fullname,
        'username': model == null ? username : model.username,
        'birthday': model == null ? birthday : model.birthday,
        'cpf': model == null ? cpf : model.cpf,
        'rg': model == null ? rg : model.rg,
        'gender': model == null ? gender : model.gender,
        'id': model == null ? id : model.id,
        'phone': model == null ? phone : model.phone,
        'status': model == null ? status : model.status,
        'new_notifications':
            model == null ? newNotifications : model.newNotifications,
        'new_messages':
            model == null ? newMessages : model.newMessages,
        'new_support_messages':
            model == null ? newSupportMessages : model.newSupportMessages,
        'token_id': model == null ? tokenId : model.tokenId,
        'connected': model == null ? connected : model.connected,
        'country': model == null ? country : model.country,
        'notification_enabled':
            model == null ? notificationEnabled : model.notificationEnabled,
        'main_address': model == null ? mainAddress : model.mainAddress,
        'email': model == null ? email : model.email,
        'user_promotional_code':
            model == null ? userPromotionalCode : model.userPromotionalCode,
        'was_invited': model == null ? wasInvited : model.wasInvited,
        'customer_id': model == null ? customerId : model.customerId,
        'account_balance': model == null ? accountBalance : model.accountBalance,
      };
}
