import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';
import 'package:isilahtitiktitik/model/user.dart';

ClaimPrizeModel claimPrizeModelFromJson(String str) =>
    ClaimPrizeModel.fromJson(json.decode(str));

String claimPrizeModelToJson(ClaimPrizeModel data) =>
    json.encode(data.toJson());

class ClaimPrizeModel {
  ClaimPrizeModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  ClaimPrizeData? data;
  int? status;

  factory ClaimPrizeModel.fromJson(Map<String, dynamic> json) =>
      ClaimPrizeModel(
        message: MessageData.fromJson(json["message"]),
        data: ClaimPrizeData.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class ClaimPrizeData {
  ClaimPrizeData({
    this.shipment,
    this.token,
    this.user,
  });

  ShipmentUser? shipment;
  String? token;
  UserClass? user;

  factory ClaimPrizeData.fromJson(Map<String, dynamic> json) => ClaimPrizeData(
        shipment: ShipmentUser.fromJson(json["shipment"]),
        token: json["token"],
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "shipment": shipment!.toJson(),
        "token": token,
        "user": user!.toJson(),
      };
}
