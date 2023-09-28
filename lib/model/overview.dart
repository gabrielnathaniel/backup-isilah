// To parse this JSON data, do
//
//     final overviewModel = overviewModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

OverviewModel overviewModelFromJson(String str) =>
    OverviewModel.fromJson(json.decode(str));

String overviewModelToJson(OverviewModel data) => json.encode(data.toJson());

class OverviewModel {
  OverviewModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataOverview? data;

  factory OverviewModel.fromJson(Map<String, dynamic> json) => OverviewModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json["data"] == null ? null : DataOverview.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data == null ? null : data!.toJson(),
      };
}

class DataOverview {
  DataOverview({
    this.header,
    this.detail,
  });

  HeaderOverview? header;
  List<DetailOverview>? detail;

  factory DataOverview.fromJson(Map<String, dynamic> json) => DataOverview(
        header: HeaderOverview.fromJson(json["header"]),
        detail: List<DetailOverview>.from(
            json["detail"].map((x) => DetailOverview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "detail": List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class DetailOverview {
  DetailOverview({
    this.categoryId,
    this.category,
    this.totalAnswer,
    this.totalCorrectAnswer,
    this.power,
  });

  int? categoryId;
  String? category;
  int? totalAnswer;
  String? totalCorrectAnswer;
  String? power;

  factory DetailOverview.fromJson(Map<String, dynamic> json) => DetailOverview(
        categoryId: json["category_id"],
        category: json["category"],
        totalAnswer: json["total_answer"],
        totalCorrectAnswer: json["total_correct_answer"],
        power: json["power"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category": category,
        "total_answer": totalAnswer,
        "total_correct_answer": totalCorrectAnswer,
        "power": power,
      };
}

class HeaderOverview {
  HeaderOverview({
    this.userId,
    this.photo,
    this.playing,
    this.averagePlayingTime,
  });

  int? userId;
  String? photo;
  int? playing;
  String? averagePlayingTime;

  factory HeaderOverview.fromJson(Map<String, dynamic> json) => HeaderOverview(
        userId: json["user_id"],
        photo: json["photo"],
        playing: json["playing"],
        averagePlayingTime: json["average_playing_time"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "photo": photo,
        "playing": playing,
        "average_playing_time": averagePlayingTime,
      };
}
