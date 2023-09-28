// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  NotificationModelData? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: NotificationModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class NotificationModelData {
  NotificationModelData({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataNotification? data;

  factory NotificationModelData.fromJson(Map<String, dynamic> json) =>
      NotificationModelData(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataNotification.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataNotification {
  DataNotification({
    this.latest,
    this.oldest,
  });

  EstNotification? latest;
  EstNotification? oldest;

  factory DataNotification.fromJson(Map<String, dynamic> json) =>
      DataNotification(
        latest: EstNotification.fromJson(json["latest"]),
        oldest: EstNotification.fromJson(json["oldest"]),
      );

  Map<String, dynamic> toJson() => {
        "latest": latest!.toJson(),
        "oldest": oldest!.toJson(),
      };
}

class EstNotification {
  EstNotification({
    this.data,
  });

  List<ResultDataNotification>? data;

  factory EstNotification.fromJson(Map<String, dynamic> json) =>
      EstNotification(
        data: List<ResultDataNotification>.from(
            json["data"].map((x) => ResultDataNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ResultDataNotification {
  ResultDataNotification({
    this.id,
    this.refference,
    this.refferenceId,
    this.date,
    this.title,
    this.content,
    this.status,
    this.flag,
  });

  int? id;
  String? refference;
  String? refferenceId;
  DateTime? date;
  String? title;
  String? content;
  int? status;
  int? flag;

  factory ResultDataNotification.fromJson(Map<String, dynamic> json) =>
      ResultDataNotification(
        id: json["id"],
        refference: json["refference"],
        refferenceId: json["refference_id"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
        content: json["content"],
        status: json["status"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refference": refference,
        "refference_id": refferenceId,
        "date": date!.toIso8601String(),
        "title": title,
        "content": content,
        "status": status,
        "flag": flag,
      };
}
