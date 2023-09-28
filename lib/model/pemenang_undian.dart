import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

PemenangUndianModel pemenangUndianModelFromJson(String str) =>
    PemenangUndianModel.fromJson(json.decode(str));

String pemenangUndianModelToJson(PemenangUndianModel data) =>
    json.encode(data.toJson());

class PemenangUndianModel {
  PemenangUndianModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataPemenangUndianBody? data;

  factory PemenangUndianModel.fromJson(Map<String, dynamic> json) =>
      PemenangUndianModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataPemenangUndianBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataPemenangUndianBody {
  DataPemenangUndianBody({
    this.header,
    this.detail,
  });

  PemenangUndianHeader? header;
  List<DetailPemenang>? detail;

  factory DataPemenangUndianBody.fromJson(Map<String, dynamic> json) =>
      DataPemenangUndianBody(
        header: PemenangUndianHeader.fromJson(json["header"]),
        detail: json["detail"] == null
            ? null
            : List<DetailPemenang>.from(
                json["detail"].map((x) => DetailPemenang.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class PemenangUndianHeader {
  PemenangUndianHeader({
    this.description,
  });

  String? description;

  factory PemenangUndianHeader.fromJson(Map<String, dynamic> json) =>
      PemenangUndianHeader(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class DetailPemenang {
  DetailPemenang(
      {this.prizeId,
      this.drawnOn,
      this.photo,
      this.prize,
      this.headline,
      this.description,
      this.status,
      this.winner});

  int? prizeId;
  String? drawnOn;
  String? photo;
  String? prize;
  String? headline;
  String? description;
  int? status;
  List<Winner>? winner;

  factory DetailPemenang.fromJson(Map<String, dynamic> json) => DetailPemenang(
        prizeId: json["prizeId"],
        drawnOn: json["drawnOn"],
        photo: json["photo"],
        prize: json["prize"],
        headline: json["headline"],
        description: json["description"],
        status: json["status"],
        winner: json["winner"] == null
            ? null
            : List<Winner>.from(json["winner"].map((x) => Winner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "prize_id": prizeId,
        "drawn_on": drawnOn,
        "photo": photo,
        "prize": prize,
        "headline": headline,
        "description": description,
        "status": status,
        "winner": winner == null
            ? null
            : List<dynamic>.from(winner!.map((x) => x.toJson())),
      };
}

class Winner {
  Winner({this.code, this.fullName, this.fullNameAsterix});
  String? code;
  String? fullName;
  String? fullNameAsterix;

  factory Winner.fromJson(Map<String, dynamic> json) => Winner(
        code: json["code"],
        fullName: json["full_name"],
        fullNameAsterix: json["full_name_asterix"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "full_name": fullName,
        "full_name_asterix": fullNameAsterix,
      };
}
