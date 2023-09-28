// To parse this JSON data, do
//
//     final urbanVillageModel = urbanVillageModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

UrbanVillageModel urbanVillageModelFromJson(String str) =>
    UrbanVillageModel.fromJson(json.decode(str));

String urbanVillageModelToJson(UrbanVillageModel data) =>
    json.encode(data.toJson());

class UrbanVillageModel {
  UrbanVillageModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataUrbanVillage>? data;

  factory UrbanVillageModel.fromJson(Map<String, dynamic> json) =>
      UrbanVillageModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: List<DataUrbanVillage>.from(
            json["data"].map((x) => DataUrbanVillage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataUrbanVillage {
  DataUrbanVillage({
    this.id,
    this.subdistrictId,
    this.urbanVillage,
    this.postalCode,
  });

  int? id;
  int? subdistrictId;
  String? urbanVillage;
  String? postalCode;

  factory DataUrbanVillage.fromJson(Map<String, dynamic> json) =>
      DataUrbanVillage(
        id: json["id"],
        subdistrictId: json["subdistrict_id"],
        urbanVillage: json["urban_village"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subdistrict_id": subdistrictId,
        "urban_village": urbanVillage,
        "postal_code": postalCode,
      };
}
