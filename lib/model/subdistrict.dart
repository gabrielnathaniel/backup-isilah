// To parse this JSON data, do
//
//     final subdistrictModel = subdistrictModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

SubdistrictModel subdistrictModelFromJson(String str) =>
    SubdistrictModel.fromJson(json.decode(str));

String subdistrictModelToJson(SubdistrictModel data) =>
    json.encode(data.toJson());

class SubdistrictModel {
  SubdistrictModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataSubdictrict>? data;

  factory SubdistrictModel.fromJson(Map<String, dynamic> json) =>
      SubdistrictModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: List<DataSubdictrict>.from(
            json["data"].map((x) => DataSubdictrict.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataSubdictrict {
  DataSubdictrict({
    this.id,
    this.regencyId,
    this.subdistrict,
  });

  int? id;
  int? regencyId;
  String? subdistrict;

  factory DataSubdictrict.fromJson(Map<String, dynamic> json) =>
      DataSubdictrict(
        id: json["id"],
        regencyId: json["regency_id"],
        subdistrict: json["subdistrict"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regency_id": regencyId,
        "subdistrict": subdistrict,
      };
}
