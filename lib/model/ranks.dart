import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

RanksModel ranksModelFromJson(String str) =>
    RanksModel.fromJson(json.decode(str));

String ranksModelToJson(RanksModel data) => json.encode(data.toJson());

class RanksModel {
  RanksModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataBody? data;

  factory RanksModel.fromJson(Map<String, dynamic> json) => RanksModel(
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
    this.total,
  });

  int? currentPage;
  List<DataRanks>? data;
  int? total;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        currentPage: json["current_page"],
        total: json["total"],
        data: json["data"] == null
            ? null
            : List<DataRanks>.from(
                json["data"].map((x) => DataRanks.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataRanks {
  DataRanks({
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
  int? experience;
  int? rank;
  int? rankStatus;

  factory DataRanks.fromJson(Map<String, dynamic> json) => DataRanks(
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
