// To parse this JSON data, do
//
//     final leaderboardTreasureChestModel = leaderboardTreasureChestModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

LeaderboardTreasureChestModel leaderboardTreasureChestModelFromJson(
        String str) =>
    LeaderboardTreasureChestModel.fromJson(json.decode(str));

String leaderboardTreasureChestModelToJson(
        LeaderboardTreasureChestModel data) =>
    json.encode(data.toJson());

class LeaderboardTreasureChestModel {
  int? status;
  MessageData? message;
  DataLeaderboardTreasureChest? data;

  LeaderboardTreasureChestModel({
    this.status,
    this.message,
    this.data,
  });

  factory LeaderboardTreasureChestModel.fromJson(Map<String, dynamic> json) =>
      LeaderboardTreasureChestModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DataLeaderboardTreasureChest.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class DataLeaderboardTreasureChest {
  int? currentPage;
  List<LeaderboardTreasureChestList>? data;
  int? total;

  DataLeaderboardTreasureChest({
    this.currentPage,
    this.data,
    this.total,
  });

  factory DataLeaderboardTreasureChest.fromJson(Map<String, dynamic> json) =>
      DataLeaderboardTreasureChest(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<LeaderboardTreasureChestList>.from(json["data"]!
                .map((x) => LeaderboardTreasureChestList.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
      };
}

class LeaderboardTreasureChestList {
  int? seq;
  int? userId;
  String? photo;
  String? email;
  String? phone;
  String? fullName;
  String? username;
  String? gender;
  String? birthdate;
  int? age;
  String? profession;
  String? province;
  String? regency;
  String? subdistrict;
  String? urbanVillage;
  String? level;
  int? payPoint;
  int? payExperience;
  int? prizePoint;
  int? prizeExperience;
  int? quizTotal;
  int? answerTotal;
  int? answerCorrect;
  int? answerIncorrect;
  int? status;
  String? statusLabel;

  LeaderboardTreasureChestList({
    this.seq,
    this.userId,
    this.photo,
    this.email,
    this.phone,
    this.fullName,
    this.username,
    this.gender,
    this.birthdate,
    this.age,
    this.profession,
    this.province,
    this.regency,
    this.subdistrict,
    this.urbanVillage,
    this.level,
    this.payPoint,
    this.payExperience,
    this.prizePoint,
    this.prizeExperience,
    this.quizTotal,
    this.answerTotal,
    this.answerCorrect,
    this.answerIncorrect,
    this.status,
    this.statusLabel,
  });

  factory LeaderboardTreasureChestList.fromJson(Map<String, dynamic> json) =>
      LeaderboardTreasureChestList(
        seq: json["seq"],
        userId: json["user_id"],
        photo: json["photo"],
        email: json["email"],
        phone: json["phone"],
        fullName: json["full_name"],
        username: json["username"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        age: json["age"],
        profession: json["profession"],
        province: json["province"],
        regency: json["regency"],
        subdistrict: json["subdistrict"],
        urbanVillage: json["urban_village"],
        level: json["level"],
        payPoint: json["pay_point"],
        payExperience: json["pay_experience"],
        prizePoint: json["prize_point"],
        prizeExperience: json["prize_experience"],
        quizTotal: json["quiz_total"],
        answerTotal: json["answer_total"],
        answerCorrect: json["answer_correct"],
        answerIncorrect: json["answer_incorrect"],
        status: json["status"],
        statusLabel: json["status_label"],
      );

  Map<String, dynamic> toJson() => {
        "seq": seq,
        "user_id": userId,
        "photo": photo,
        "email": email,
        "phone": phone,
        "full_name": fullName,
        "username": username,
        "gender": gender,
        "birthdate": birthdate,
        "age": age,
        "profession": profession,
        "province": province,
        "regency": regency,
        "subdistrict": subdistrict,
        "urban_village": urbanVillage,
        "level": level,
        "pay_point": payPoint,
        "pay_experience": payExperience,
        "prize_point": prizePoint,
        "prize_experience": prizeExperience,
        "quiz_total": quizTotal,
        "answer_total": answerTotal,
        "answer_correct": answerCorrect,
        "answer_incorrect": answerIncorrect,
        "status": status,
        "status_label": statusLabel,
      };
}
