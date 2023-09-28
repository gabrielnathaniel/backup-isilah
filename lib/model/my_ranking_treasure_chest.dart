// To parse this JSON data, do
//
//     final myRankingTreaseureChestModel = myRankingTreaseureChestModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

MyRankingTreaseureChestModel myRankingTreaseureChestModelFromJson(String str) =>
    MyRankingTreaseureChestModel.fromJson(json.decode(str));

String myRankingTreaseureChestModelToJson(MyRankingTreaseureChestModel data) =>
    json.encode(data.toJson());

class MyRankingTreaseureChestModel {
  int? status;
  MessageData? message;
  DataMyRankingTreaseureChest? data;

  MyRankingTreaseureChestModel({
    this.status,
    this.message,
    this.data,
  });

  factory MyRankingTreaseureChestModel.fromJson(Map<String, dynamic> json) =>
      MyRankingTreaseureChestModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DataMyRankingTreaseureChest.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class DataMyRankingTreaseureChest {
  int? seq;
  int? userId;
  String? email;
  String? phone;
  String? username;
  String? fullName;
  String? photo;
  String? gender;
  DateTime? birthdate;
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
  int? questionQty;
  int? answerTotal;
  int? answerCorrect;
  int? answerIncorrect;
  int? status;
  String? statusLabel;

  DataMyRankingTreaseureChest({
    this.seq,
    this.userId,
    this.email,
    this.phone,
    this.username,
    this.fullName,
    this.photo,
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
    this.questionQty,
    this.answerTotal,
    this.answerCorrect,
    this.answerIncorrect,
    this.status,
    this.statusLabel,
  });

  factory DataMyRankingTreaseureChest.fromJson(Map<String, dynamic> json) =>
      DataMyRankingTreaseureChest(
        seq: json["seq"],
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        fullName: json["full_name"],
        photo: json["photo"],
        gender: json["gender"],
        birthdate: json["birthdate"] == null
            ? null
            : DateTime.parse(json["birthdate"]),
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
        questionQty: json["question_qty"],
        answerTotal: json["answer_total"],
        answerCorrect: json["answer_correct"],
        answerIncorrect: json["answer_incorrect"],
        status: json["status"],
        statusLabel: json["status_label"],
      );

  Map<String, dynamic> toJson() => {
        "seq": seq,
        "user_id": userId,
        "email": email,
        "phone": phone,
        "username": username,
        "full_name": fullName,
        "photo": photo,
        "gender": gender,
        "birthdate":
            "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}",
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
        "question_qty": questionQty,
        "answer_total": answerTotal,
        "answer_correct": answerCorrect,
        "answer_incorrect": answerIncorrect,
        "status": status,
        "status_label": statusLabel,
      };
}
