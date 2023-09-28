import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

PrizeModel prizeModelFromJson(String str) =>
    PrizeModel.fromJson(json.decode(str));

String prizeModelToJson(PrizeModel data) => json.encode(data.toJson());

class PrizeModel {
  PrizeModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataBody? data;

  factory PrizeModel.fromJson(Map<String, dynamic> json) => PrizeModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataBody {
  DataBody({
    this.currentPage,
    this.data,
  });

  int? currentPage;
  List<PrizeDataDetail>? data;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? null
            : List<PrizeDataDetail>.from(
                json["data"].map((x) => PrizeDataDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PrizeDataDetail {
  PrizeDataDetail({
    this.type,
    this.userLevelId,
    this.level,
    this.levelLogo,
    this.levelExperienceFrom,
    this.levelCanClaim,
    this.categoryId,
    this.category,
    this.prizeId,
    this.prize,
    this.photo,
    this.description,
    this.qty,
    this.claimed,
    this.availabeQty,
    this.pricePoint,
    this.priceExperience,
    this.priceRefferal,
    this.availabeTo,
    this.availableAt,
    this.drawnOn,
    this.status,
  });

  String? type;
  int? userLevelId;
  String? level;
  String? levelLogo;
  int? levelExperienceFrom;
  int? levelCanClaim;
  int? categoryId;
  String? category;
  int? prizeId;
  String? prize;
  String? photo;
  String? description;
  int? qty;
  String? claimed;
  String? availabeQty;
  int? pricePoint;
  int? priceExperience;
  int? priceRefferal;
  String? availabeTo;
  String? availableAt;
  String? drawnOn;
  int? status;

  factory PrizeDataDetail.fromJson(Map<String, dynamic> json) =>
      PrizeDataDetail(
        type: json["type"],
        userLevelId: json["user_level_id"],
        level: json["level"],
        levelLogo: json["level_logo"],
        levelExperienceFrom: json["level_experience_from"],
        levelCanClaim: json["level_can_claim"],
        categoryId: json["category_id"],
        category: json["category"],
        prizeId: json["prize_id"],
        prize: json["prize"],
        photo: json["photo"],
        description: json["description"],
        qty: json["qty"],
        claimed: json["claimed"],
        availabeQty: json["availabe_qty"],
        pricePoint: json["price_point"],
        priceExperience: json["price_experience"],
        priceRefferal: json["price_refferal"],
        availabeTo: json["available_to"],
        availableAt: json["available_at"],
        drawnOn: json["drawn_on"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "user_level_id": userLevelId,
        "level": level,
        "level_logo": levelLogo,
        "level_experience_from": levelExperienceFrom,
        "level_can_claim": levelCanClaim,
        "category_id": categoryId,
        "category": category,
        "prize_id": prizeId,
        "prize": prize,
        "photo": photo,
        "description": description,
        "qty": qty,
        "claimed": claimed,
        "availabe_qty": availabeQty,
        "price_point": pricePoint,
        "price_experience": priceExperience,
        "price_refferal": priceRefferal,
        "available_to": availabeTo,
        "available_at": availableAt,
        "drawn_on": drawnOn,
        "status": status,
      };
}
