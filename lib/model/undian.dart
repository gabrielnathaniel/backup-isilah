import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

UndianModel undianModelFromJson(String str) =>
    UndianModel.fromJson(json.decode(str));

String undianModelToJson(UndianModel data) => json.encode(data.toJson());

class UndianModel {
  UndianModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataUndianBody? data;

  factory UndianModel.fromJson(Map<String, dynamic> json) => UndianModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataUndianBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataUndianBody {
  DataUndianBody({
    this.currentPage,
    this.data,
  });

  int? currentPage;
  List<UndianDataDetail>? data;

  factory DataUndianBody.fromJson(Map<String, dynamic> json) => DataUndianBody(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? null
            : List<UndianDataDetail>.from(
                json["data"].map((x) => UndianDataDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UndianDataDetail {
  UndianDataDetail({
    this.drawnOn,
    this.photo,
    this.total,
  });

  String? drawnOn;
  String? photo;
  int? total;

  factory UndianDataDetail.fromJson(Map<String, dynamic> json) =>
      UndianDataDetail(
        drawnOn: json["drawn_on"],
        photo: json["photo"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "drawn_on": drawnOn,
        "photo": photo,
        "total": total,
      };
}
