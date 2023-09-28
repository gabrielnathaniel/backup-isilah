// To parse this JSON data, do
//
//     final usernameCheckModel = usernameCheckModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

UsernameCheckModel usernameCheckModelFromJson(String str) =>
    UsernameCheckModel.fromJson(json.decode(str));

String usernameCheckModelToJson(UsernameCheckModel data) =>
    json.encode(data.toJson());

class UsernameCheckModel {
  int? status;
  MessageData? message;
  DataUsernameCheck? data;

  UsernameCheckModel({
    this.status,
    this.message,
    this.data,
  });

  factory UsernameCheckModel.fromJson(Map<String, dynamic> json) =>
      UsernameCheckModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DataUsernameCheck.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class DataUsernameCheck {
  String? username;
  DateTime? usernameUpdatedAt;
  dynamic changeUsernameCost;
  dynamic changeUsernameDuration;
  DateTime? changeUsernameAvailableAt;
  int? statusAvailableAt;

  DataUsernameCheck({
    this.username,
    this.usernameUpdatedAt,
    this.changeUsernameCost,
    this.changeUsernameDuration,
    this.changeUsernameAvailableAt,
    this.statusAvailableAt,
  });

  factory DataUsernameCheck.fromJson(Map<String, dynamic> json) =>
      DataUsernameCheck(
        username: json["username"],
        usernameUpdatedAt: json["username_updated_at"] == null
            ? null
            : DateTime.parse(json["username_updated_at"]),
        changeUsernameCost: json["change_username_cost"],
        changeUsernameDuration: json["change_username_duration"],
        changeUsernameAvailableAt: json["change_username_available_at"] == null
            ? null
            : DateTime.parse(json["change_username_available_at"]),
        statusAvailableAt: json["status_available_at"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "username_updated_at": usernameUpdatedAt?.toIso8601String(),
        "change_username_cost": changeUsernameCost,
        "change_username_duration": changeUsernameDuration,
        "change_username_available_at":
            changeUsernameAvailableAt?.toIso8601String(),
        "status_available_at": statusAvailableAt,
      };
}
