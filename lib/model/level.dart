import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

LevelModel levelModelFromJson(String str) =>
    LevelModel.fromJson(json.decode(str));

String levelModelToJson(LevelModel data) => json.encode(data.toJson());

class LevelModel {
  LevelModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataLevel>? data;

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : List<DataLevel>.from(
                json["data"].map((x) => DataLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataLevel {
  DataLevel({
    this.id,
    this.level,
    this.experienceFrom,
    this.experienceTo,
    this.cycle,
    this.logo,
    this.description,
  });

  int? id;
  String? level;
  int? experienceFrom;
  int? experienceTo;
  int? cycle;
  String? logo;
  String? description;

  factory DataLevel.fromJson(Map<String, dynamic> json) => DataLevel(
        id: json["id"],
        level: json["level"],
        experienceFrom: json["experience_from"],
        experienceTo: json["experience_to"],
        cycle: json["cycle"],
        logo: json["logo"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "experience_from": experienceFrom,
        "experience_to": experienceTo,
        "cycle": cycle,
        "logo": logo,
        "description": description,
      };
}
