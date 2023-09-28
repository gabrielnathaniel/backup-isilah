// To parse this JSON data, do
//
//     final versionModel = versionModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

VersionModel versionModelFromJson(String str) =>
    VersionModel.fromJson(json.decode(str));

String versionModelToJson(VersionModel data) => json.encode(data.toJson());

class VersionModel {
  VersionModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataVersion? data;

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataVersion.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataVersion {
  DataVersion({
    this.status,
    this.link,
    this.deviceVersion,
    this.latestVersion,
  });

  int? status;
  String? link;
  String? deviceVersion;
  String? latestVersion;

  factory DataVersion.fromJson(Map<String, dynamic> json) => DataVersion(
        status: json["status"],
        link: json["link"],
        deviceVersion: json["device_version"],
        latestVersion: json["latest_version"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "link": link,
        "device_version": deviceVersion,
        "latest_version": latestVersion,
      };
}
