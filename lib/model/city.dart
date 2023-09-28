// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  CityModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataCity>? data;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data:
            List<DataCity>.from(json["data"].map((x) => DataCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataCity {
  DataCity({
    this.id,
    this.provinceId,
    this.regency,
  });

  int? id;
  int? provinceId;
  String? regency;

  factory DataCity.fromJson(Map<String, dynamic> json) => DataCity(
        id: json["id"],
        provinceId: json["province_id"],
        regency: json["regency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "regency": regency,
      };
}
