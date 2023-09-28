import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ReactionModel reactionModelFromJson(String str) =>
    ReactionModel.fromJson(json.decode(str));

String reactionModelToJson(ReactionModel data) => json.encode(data.toJson());

class ReactionModel {
  ReactionModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  ReactionBody? data;

  factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: ReactionBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class ReactionBody {
  ReactionBody({
    this.word,
    this.audio,
  });

  String? word;
  String? audio;

  factory ReactionBody.fromJson(Map<String, dynamic> json) => ReactionBody(
        word: json["word"],
        audio: json["audio"],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "audio": audio,
      };
}
