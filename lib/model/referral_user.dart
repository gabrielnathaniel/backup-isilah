// To parse this JSON data, do
//
//     final referralModel = referralModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';
import 'package:isilahtitiktitik/model/referral_header.dart';
import 'package:isilahtitiktitik/model/referral_link_page.dart';
import 'package:isilahtitiktitik/model/user_id.dart';

ReferralUserModel referralUserModelFromJson(String str) =>
    ReferralUserModel.fromJson(json.decode(str));

String referralUserModelToJson(ReferralUserModel data) =>
    json.encode(data.toJson());

class ReferralUserModel {
  ReferralUserModel({
    this.status,
    this.message,
    this.user,
    this.data,
  });

  int? status;
  MessageData? message;
  UserId? user;
  ReferralUserModelData? data;

  factory ReferralUserModel.fromJson(Map<String, dynamic> json) =>
      ReferralUserModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        user: UserId.fromJson(json["user"]),
        data: ReferralUserModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "user": user!.toJson(),
        "data": data!.toJson(),
      };
}

class ReferralUserModelData {
  ReferralUserModelData({
    this.header,
    this.data,
  });

  HeaderReferral? header;
  ResultReferralUser? data;

  factory ReferralUserModelData.fromJson(Map<String, dynamic> json) =>
      ReferralUserModelData(
        header: HeaderReferral.fromJson(json["header"]),
        data: ResultReferralUser.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "data": data!.toJson(),
      };
}

class ResultReferralUser {
  ResultReferralUser({
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
  List<DataReferralUser>? data;
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

  factory ResultReferralUser.fromJson(Map<String, dynamic> json) =>
      ResultReferralUser(
        currentPage: json["current_page"],
        data: List<DataReferralUser>.from(
            json["data"].map((x) => DataReferralUser.fromJson(x))),
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

class DataReferralUser {
  DataReferralUser({
    this.id,
    this.username,
    this.fullName,
    this.photo,
    this.point,
    this.rank,
    this.rankStatus,
    this.level,
    this.online,
    this.statusValid,
  });

  int? id;
  String? username;
  String? fullName;
  String? photo;
  int? point;
  int? rank;
  int? rankStatus;
  String? level;
  int? online;
  int? statusValid;

  factory DataReferralUser.fromJson(Map<String, dynamic> json) =>
      DataReferralUser(
        id: json["id"],
        username: json["username"],
        fullName: json["full_name"],
        photo: json["photo"],
        point: json["point"],
        rank: json["rank"],
        rankStatus: json["rank_status"],
        level: json["level"],
        online: json["online"],
        statusValid: json["status_valid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "full_name": fullName,
        "photo": photo,
        "point": point,
        "rank": rank,
        "rank_status": rankStatus,
        "level": level,
        "online": online,
        "status_valid": statusValid,
      };
}
