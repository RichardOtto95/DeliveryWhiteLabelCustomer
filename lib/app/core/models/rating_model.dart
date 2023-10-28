import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  Timestamp? createdAt;
  double? rating;
  String? opnion;
  String? answer;
  String? evaluatedCollection;
  String? evaluatedId;
  String? status;
  String? id;
  String? orderId;
  bool? answered;

  Rating({
    this.createdAt,
    this.rating,
    this.opnion,
    this.answer,
    this.evaluatedCollection,
    this.evaluatedId,
    this.status,
    this.id,
    this.orderId,
    this.answered,
  });

  factory Rating.fromDoc(DocumentSnapshot doc) => Rating(
        createdAt: doc["created_at"],
        rating: doc["rating"],
        opnion: doc["opnion"],
        answer: doc["answer"],
        evaluatedCollection: doc["evaluated_collection"],
        evaluatedId: doc["evaluated_id"],
        status: doc["status"],
        id: doc["id"],
        orderId: doc["order_id"],
        answered: doc["answered"],
      );

  Map<String, dynamic> toJson({Rating? model}) => model != null
      ? {
          "created_at": model.createdAt,
          "rating": model.rating,
          "opnion": model.opnion,
          "answer": model.answer,
          "evaluated_collection": model.evaluatedCollection,
          "evaluated_id": model.evaluatedId,
          "status": model.status,
          "id": model.id,
          "order_id": model.orderId,
          "answered": model.answered,
        }
      : {
          "created_at": createdAt,
          "rating": rating,
          "opnion": opnion,
          "answer": answer,
          "evaluated_collection": evaluatedCollection,
          "evaluated_id": evaluatedId,
          "status": status,
          "id": id,
          "order_id": orderId,
          "answered": answered,
        };
}
