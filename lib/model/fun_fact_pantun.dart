// To parse this JSON data, do
//
//     final funFactPantunModel = funFactPantunModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

FunFactPantunModel funFactPantunModelFromJson(String str) =>
    FunFactPantunModel.fromJson(json.decode(str));

String funFactPantunModelToJson(FunFactPantunModel data) =>
    json.encode(data.toJson());

class FunFactPantunModel {
  int? status;
  MessageData? message;
  DataFunFactPantun? data;

  FunFactPantunModel({
    this.status,
    this.message,
    this.data,
  });

  factory FunFactPantunModel.fromJson(Map<String, dynamic> json) =>
      FunFactPantunModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DataFunFactPantun.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class DataFunFactPantun {
  String? word;

  DataFunFactPantun({
    this.word,
  });

  factory DataFunFactPantun.fromJson(Map<String, dynamic> json) =>
      DataFunFactPantun(
        word: json["word"],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
      };
}
