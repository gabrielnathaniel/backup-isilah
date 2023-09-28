// To parse this JSON data, do
//
//     final quetionsViewModel = quetionsViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

QuetionsViewModel quetionsViewModelFromJson(String str) =>
    QuetionsViewModel.fromJson(json.decode(str));

String quetionsViewModelToJson(QuetionsViewModel data) =>
    json.encode(data.toJson());

class QuetionsViewModel {
  int? status;
  MessageData? message;
  DataQuetionsView? data;

  QuetionsViewModel({
    this.status,
    this.message,
    this.data,
  });

  factory QuetionsViewModel.fromJson(Map<String, dynamic> json) =>
      QuetionsViewModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DataQuetionsView.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class DataQuetionsView {
  int? questionId;
  String? question;
  String? answer;
  String? image;
  String? text;
  String? video;
  String? level;
  String? category;
  String? source;

  DataQuetionsView({
    this.questionId,
    this.question,
    this.answer,
    this.image,
    this.text,
    this.video,
    this.level,
    this.category,
    this.source,
  });

  factory DataQuetionsView.fromJson(Map<String, dynamic> json) =>
      DataQuetionsView(
        questionId: json["question_id"],
        question: json["question"],
        answer: json["answer"],
        image: json["image"],
        text: json["text"],
        video: json["video"],
        level: json["level"],
        category: json["category"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "answer": answer,
        "image": image,
        "text": text,
        "video": video,
        "level": level,
        "category": category,
        "source": source,
      };
}
