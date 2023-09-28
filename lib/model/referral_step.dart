// To parse this JSON data, do
//
//     final referralModel = referralModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';
import 'package:isilahtitiktitik/model/referral_header.dart';
import 'package:isilahtitiktitik/model/referral_link_page.dart';
import 'package:isilahtitiktitik/model/user_id.dart';

ReferralStepModel referralStepModelFromJson(String str) =>
    ReferralStepModel.fromJson(json.decode(str));

String referralStepModelToJson(ReferralStepModel data) =>
    json.encode(data.toJson());

class ReferralStepModel {
  ReferralStepModel({
    this.status,
    this.message,
    this.user,
    this.data,
  });

  int? status;
  MessageData? message;
  UserId? user;
  ReferralStepModelData? data;

  factory ReferralStepModel.fromJson(Map<String, dynamic> json) =>
      ReferralStepModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        user: UserId.fromJson(json["user"]),
        data: ReferralStepModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "user": user!.toJson(),
        "data": data!.toJson(),
      };
}

class ReferralStepModelData {
  ReferralStepModelData({
    this.header,
    this.data,
  });

  HeaderReferral? header;
  ResultReferralStep? data;

  factory ReferralStepModelData.fromJson(Map<String, dynamic> json) =>
      ReferralStepModelData(
        header: HeaderReferral.fromJson(json["header"]),
        data: ResultReferralStep.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "data": data!.toJson(),
      };
}

class ResultReferralStep {
  ResultReferralStep({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<DataStep>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<ReferralLinkPage>? links;
  dynamic nextPageUrl;
  String? path;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory ResultReferralStep.fromJson(Map<String, dynamic> json) =>
      ResultReferralStep(
        currentPage: json["current_page"],
        data:
            List<DataStep>.from(json["data"].map((x) => DataStep.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<ReferralLinkPage>.from(
            json["links"].map((x) => ReferralLinkPage.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class DataStep {
  DataStep({
    this.id,
    this.prize,
    this.prizePoint,
    this.priceRefferal,
    this.status,
    this.statusLabel,
  });

  int? id;
  String? prize;
  int? prizePoint;
  int? priceRefferal;
  int? status;
  String? statusLabel;

  factory DataStep.fromJson(Map<String, dynamic> json) => DataStep(
        id: json["id"],
        prize: json["prize"],
        prizePoint: json["prize_point"],
        priceRefferal: json["price_refferal"],
        status: json["status"],
        statusLabel: json["status_label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prize": prize,
        "prize_point": prizePoint,
        "price_refferal": priceRefferal,
        "status": status,
        "status_label": statusLabel,
      };
}
