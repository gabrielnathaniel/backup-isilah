import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

TreasureChestAnswer treasureChestAnswerFromJson(String str) =>
    TreasureChestAnswer.fromJson(json.decode(str));

String treasureChestAnswerToJson(TreasureChestAnswer data) =>
    json.encode(data.toJson());

class TreasureChestAnswer {
  TreasureChestAnswer({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  TreasureChestAnswerBody? data;
  int? status;

  factory TreasureChestAnswer.fromJson(Map<String, dynamic> json) =>
      TreasureChestAnswer(
        message: MessageData.fromJson(json["message"]),
        data: TreasureChestAnswerBody.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class TreasureChestAnswerBody {
  TreasureChestAnswerBody({
    this.finish,
    // this.next,
  });

  int? finish;
  // DetailQuiz? next;

  factory TreasureChestAnswerBody.fromJson(Map<String, dynamic> json) =>
      TreasureChestAnswerBody(
        finish: json["finish"],
        // next: DetailQuiz.fromJson(json["next"]),
      );

  Map<String, dynamic> toJson() => {
        "finish": finish,
        // "next": next!.toJson(),
      };
}
