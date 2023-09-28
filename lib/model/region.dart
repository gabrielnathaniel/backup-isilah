// To parse this JSON data, do
//
//     final regionModel = regionModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

RegionModel regionModelFromJson(String str) =>
    RegionModel.fromJson(json.decode(str));

String regionModelToJson(RegionModel data) => json.encode(data.toJson());

class RegionModel {
  RegionModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  List<DataRegion>? data;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json['data'] == null
            ? null
            : List<DataRegion>.from(
                json["data"].map((x) => DataRegion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataRegion {
  DataRegion({
    this.provinceId,
    this.province,
    this.regencyId,
    this.regency,
    this.subdistrictId,
    this.subdistrict,
    this.urbanVillageId,
    this.urbanVillage,
    this.postalCode,
    this.address,
  });

  int? provinceId;
  String? province;
  int? regencyId;
  String? regency;
  int? subdistrictId;
  String? subdistrict;
  int? urbanVillageId;
  String? urbanVillage;
  String? postalCode;
  String? address;

  factory DataRegion.fromJson(Map<String, dynamic> json) => DataRegion(
        provinceId: json["province_id"],
        province: json["province"],
        regencyId: json["regency_id"],
        regency: json["regency"],
        subdistrictId: json["subdistrict_id"],
        subdistrict: json["subdistrict"],
        urbanVillageId: json["urban_village_id"],
        urbanVillage: json["urban_village"],
        postalCode: json["postal_code"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province": province,
        "regency_id": regencyId,
        "regency": regency,
        "subdistrict_id": subdistrictId,
        "subdistrict": subdistrict,
        "urban_village_id": urbanVillageId,
        "urban_village": urbanVillage,
        "postal_code": postalCode,
        "address": address,
      };
}
