import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';
import 'package:isilahtitiktitik/model/region.dart';

RegionPostalCodeModel regionPostalCodeModelFromJson(String str) =>
    RegionPostalCodeModel.fromJson(json.decode(str));

String regionPostalCodeModelToJson(RegionPostalCodeModel data) =>
    json.encode(data.toJson());

class RegionPostalCodeModel {
  RegionPostalCodeModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  DataRegion? data;
  int? status;

  factory RegionPostalCodeModel.fromJson(Map<String, dynamic> json) =>
      RegionPostalCodeModel(
        message: MessageData.fromJson(json["message"]),
        data: json["data"] == null ? null : DataRegion.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data == null ? null : data!.toJson(),
        "status": status,
      };
}
