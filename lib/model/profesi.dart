// To parse this JSON data, do
//
//     final profesiModel = profesiModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ProfesiModel profesiModelFromJson(String str) =>
    ProfesiModel.fromJson(json.decode(str));

String profesiModelToJson(ProfesiModel data) => json.encode(data.toJson());

class ProfesiModel {
  ProfesiModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataProfesi>? data;

  factory ProfesiModel.fromJson(Map<String, dynamic> json) => ProfesiModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json['data'] == null
            ? null
            : List<DataProfesi>.from(
                json["data"].map((x) => DataProfesi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataProfesi {
  DataProfesi({
    this.id,
    this.profession,
    this.seq,
  });

  int? id;
  String? profession;
  int? seq;

  factory DataProfesi.fromJson(Map<String, dynamic> json) => DataProfesi(
        id: json["id"],
        profession: json["profession"],
        seq: json["seq"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profession": profession,
        "seq": seq,
      };
}
