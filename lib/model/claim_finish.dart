import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ClaimFinishModel claimFinishModelFromJson(String str) =>
    ClaimFinishModel.fromJson(json.decode(str));

String claimFinishModelToJson(ClaimFinishModel data) =>
    json.encode(data.toJson());

class ClaimFinishModel {
  ClaimFinishModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  int? status;
  List<ClaimFinishData>? data;

  factory ClaimFinishModel.fromJson(Map<String, dynamic> json) =>
      ClaimFinishModel(
        message: MessageData.fromJson(json["message"]),
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<ClaimFinishData>.from(
                json["data"].map((x) => ClaimFinishData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "status": status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ClaimFinishData {
  ClaimFinishData({
    this.id,
    this.prizeId,
    this.categoryId,
    this.category,
    this.prize,
    this.description,
    this.drawnOn,
    this.photo,
    this.code,
    this.date,
    this.pricePoint,
    this.priceExperience,
    this.qty,
    this.totalPricePoint,
    this.totalPriceExperience,
    this.status,
  });

  int? id;
  int? prizeId;
  int? categoryId;
  String? category;
  String? prize;
  String? description;
  String? drawnOn;
  String? photo;
  String? code;
  String? date;
  String? pricePoint;
  int? priceExperience;
  int? qty;
  int? totalPricePoint;
  int? totalPriceExperience;
  int? status;

  factory ClaimFinishData.fromJson(Map<String, dynamic> json) =>
      ClaimFinishData(
        id: json["id"],
        prizeId: json["prize_id"],
        categoryId: json["category_id"],
        category: json["category"],
        prize: json["prize"],
        description: json["description"],
        drawnOn: json["drawn_on"],
        photo: json["photo"],
        code: json["code"],
        date: json["date"],
        pricePoint: json["price_point"],
        priceExperience: json["price_experience"],
        qty: json["qty"],
        totalPricePoint: json["total_price_point"],
        totalPriceExperience: json["total_price_experience"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prize_id": prizeId,
        "category_id": categoryId,
        "category": category,
        "prize": prize,
        "description": description,
        "drawn_on": drawnOn,
        "photo": photo,
        "code": code,
        "date": date,
        "price_point": pricePoint,
        "price_experience": priceExperience,
        "qty": qty,
        "total_price_point": totalPricePoint,
        "total_price_experience": totalPriceExperience,
        "status": status,
      };
}
