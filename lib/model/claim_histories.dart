import 'dart:convert';

import 'package:isilahtitiktitik/model/claim_finish.dart';
import 'package:isilahtitiktitik/model/message.dart';

ClaimHistoriesModel claimHistoriesModelFromJson(String str) =>
    ClaimHistoriesModel.fromJson(json.decode(str));

String claimHistoriesModelToJson(ClaimHistoriesModel data) =>
    json.encode(data.toJson());

class ClaimHistoriesModel {
  ClaimHistoriesModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataBody? data;

  factory ClaimHistoriesModel.fromJson(Map<String, dynamic> json) =>
      ClaimHistoriesModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataBody {
  DataBody({
    this.currentPage,
    this.data,
    this.total,
  });

  int? currentPage;
  List<ClaimFinishData>? data;
  int? total;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        currentPage: json["current_page"],
        total: json["total"],
        data: json["data"] == null
            ? null
            : List<ClaimFinishData>.from(
                json["data"].map((x) => ClaimFinishData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
