// To parse this JSON data, do
//
//     final treasureChestListModel = treasureChestListModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

TreasureChestListModel treasureChestListModelFromJson(String str) =>
    TreasureChestListModel.fromJson(json.decode(str));

String treasureChestListModelToJson(TreasureChestListModel data) =>
    json.encode(data.toJson());

class TreasureChestListModel {
  int? status;
  MessageData? message;
  List<DataTreasureChestList>? data;

  TreasureChestListModel({
    this.status,
    this.message,
    this.data,
  });

  factory TreasureChestListModel.fromJson(Map<String, dynamic> json) =>
      TreasureChestListModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? []
            : List<DataTreasureChestList>.from(
                json["data"]!.map((x) => DataTreasureChestList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataTreasureChestList {
  int? id;
  String? event;
  String? prize;
  String? startDate;
  String? endDate;
  String? startFrom;
  String? startTo;
  String? description;
  int? requiredPoint;
  int? requiredExperience;
  int? joinPayPoint;
  int? joinPayExperience;
  int? prizePoolPoint;
  int? prizePoolExp;
  int? quizLimit;
  int? quizShuffle;
  int? statusJoin;
  int? statusTimer;

  DataTreasureChestList({
    this.id,
    this.event,
    this.prize,
    this.startDate,
    this.endDate,
    this.startFrom,
    this.startTo,
    this.description,
    this.requiredPoint,
    this.requiredExperience,
    this.joinPayPoint,
    this.joinPayExperience,
    this.prizePoolPoint,
    this.prizePoolExp,
    this.quizLimit,
    this.quizShuffle,
    this.statusJoin,
    this.statusTimer,
  });

  factory DataTreasureChestList.fromJson(Map<String, dynamic> json) =>
      DataTreasureChestList(
        id: json["id"],
        event: json["event"],
        prize: json["prize"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startFrom: json["start_from"],
        startTo: json["start_to"],
        description: json["description"],
        requiredPoint: json["required_point"],
        requiredExperience: json["required_experience"],
        joinPayPoint: json["join_pay_point"],
        joinPayExperience: json["join_pay_experience"],
        prizePoolPoint: json["prize_pool_point"],
        prizePoolExp: json["prize_pool_exp"],
        quizLimit: json["quiz_limit"],
        quizShuffle: json["quiz_shuffle"],
        statusJoin: json["status_join"],
        statusTimer: json["status_timer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "prize": prize,
        "start_date": startDate,
        "end_date": endDate,
        "start_from": startFrom,
        "start_to": startTo,
        "description": description,
        "required_point": requiredPoint,
        "required_experience": requiredExperience,
        "join_pay_point": joinPayPoint,
        "join_pay_experience": joinPayExperience,
        "prize_pool_point": prizePoolPoint,
        "prize_pool_exp": prizePoolExp,
        "quiz_limit": quizLimit,
        "quiz_shuffle": quizShuffle,
        "status_join": statusJoin,
        "status_timer": statusTimer,
      };
}
