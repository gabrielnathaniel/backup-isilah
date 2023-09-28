// To parse this JSON data, do
//
//     final provinceModel = provinceModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ProvinceModel provinceModelFromJson(String str) =>
    ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  ProvinceModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataProvince>? data;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: List<DataProvince>.from(
            json["data"].map((x) => DataProvince.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataProvince {
  DataProvince({
    this.id,
    this.province,
  });

  int? id;
  String? province;

  factory DataProvince.fromJson(Map<String, dynamic> json) => DataProvince(
        id: json["id"],
        province: json["province"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province": province,
      };
}
