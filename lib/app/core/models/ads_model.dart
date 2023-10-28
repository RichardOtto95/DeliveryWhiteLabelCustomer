import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Ads {
  final MainStore mainStore = Modular.get();

  List<dynamic> images;
  String title;
  String description;
  String category;
  String option;
  String type;
  String id;
  String status;
  String sellerId;
  bool isNew;
  bool paused;
  bool highlighted;
  int likeCount;
  num sellerPrice;
  num rateServicePrice;
  num totalPrice;
  double? oldPrice;
  Timestamp? createdAt;

  Ads({
    this.sellerId = '',
    this.oldPrice = 0,
    this.likeCount = 0,
    this.status = '',
    this.highlighted = false,
    this.createdAt,
    this.paused = false,
    this.id = '',
    this.option = '',
    this.images = const [],
    this.title = '',
    this.description = '',
    this.category = '',
    this.type = '',
    this.isNew = true,
    this.rateServicePrice = 0,
    this.sellerPrice = 0,
    this.totalPrice = 0,
  });

  factory Ads.fromDoc(DocumentSnapshot ds) => Ads(
        category: ds['category'],
        description: ds['description'],
        images: ds['images'],
        isNew: ds['new'],
        title: ds['title'],
        type: ds['type'],
        option: ds['option'],
        id: ds['id'],
        paused: ds['paused'],
        createdAt: ds['created_at'],
        highlighted: ds['highlighted'],
        status: ds['status'],
        likeCount: ds['like_count'],
        oldPrice: ds['old_price'].toDouble(),
        sellerId: ds['seller_id'],
        sellerPrice: ds['seller_price'],
        rateServicePrice: ds['rate_service_price'],
        totalPrice: ds['total_price'],
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'description': description,
        'images': images,
        'new': isNew,
        'title': title,
        'type': type,
        'option': option,
        'id': id,
        'created_at': createdAt,
        'paused': paused,
        'highlighted': highlighted,
        'status': status,
        'like_ount': likeCount,
        'old_price': oldPrice,
        'seller_id': sellerId,
        'seller_price': sellerPrice,
        'rate_service_price': rateServicePrice,
        'total_price': totalPrice,
      };

  /// Return a map with two fields: "length" and "rating"

  Future<Map<String, dynamic>> getRating() async {
    QuerySnapshot ratings = await FirebaseFirestore.instance
        .collection("ads")
        .doc(id)
        .collection("ratings")
        .where("status", isEqualTo: "VISIBLE")
        .get();

    double ratingGrade = 0;

    for (DocumentSnapshot rating in ratings.docs) {
      ratingGrade += rating.get("product_rating");
    }

    return {
      // "rating": 3.0,
      "rating": ratingGrade / ratings.docs.length,
      "length": ratings.docs.length,
    };
  }

  Future<Map> getIsLiked() async {
    User _user = FirebaseAuth.instance.currentUser!;
    final likesRef = FirebaseFirestore.instance
        .collection("ads")
        .doc(id)
        .collection("likes");

    int likes = (await likesRef.get()).docs.length;

    DocumentSnapshot userLike =
        await likesRef.doc(_user.uid).get();

    return {
      "liked": userLike.exists,
      "likes": likes,
    };
  }
}
