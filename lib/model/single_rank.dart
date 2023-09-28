import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

SingleUserRanksModel singleUserRanksModelFromJson(String str) =>
    SingleUserRanksModel.fromJson(json.decode(str));

String singleUserRanksModelToJson(SingleUserRanksModel data) =>
    json.encode(data.toJson());

class SingleUserRanksModel {
  SingleUserRanksModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  SingleUserDataRanks? data;

  factory SingleUserRanksModel.fromJson(Map<String, dynamic> json) =>
      SingleUserRanksModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : SingleUserDataRanks.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class SingleUserDataRanks {
  SingleUserDataRanks({
    this.userId,
    this.fullName,
    this.username,
    this.photo,
    this.point,
    this.experience,
    this.rank,
    this.rankStatus,
  });

  int? userId;
  String? fullName;
  String? username;
  String? photo;
  int? point;
  String? experience;
  int? rank;
  int? rankStatus;

  factory SingleUserDataRanks.fromJson(Map<String, dynamic> json) =>
      SingleUserDataRanks(
        userId: json["user_id"],
        fullName: json["full_name"],
        username: json["username"],
        photo: json["photo"],
        point: json["point"],
        experience: json["experience"],
        rank: json["rank"],
        rankStatus: json["rank_status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "username": username,
        "photo": photo,
        "point": point,
        "experience": experience,
        "rank": rank,
        "rank_status": rankStatus,
      };
}
