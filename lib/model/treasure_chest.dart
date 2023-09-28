import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

TreasureChestModel treasureChestModelFromJson(String str) =>
    TreasureChestModel.fromJson(json.decode(str));

String treasureChestModelToJson(TreasureChestModel data) =>
    json.encode(data.toJson());

class TreasureChestModel {
  TreasureChestModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  TreasureChestBody? data;
  int? status;

  factory TreasureChestModel.fromJson(Map<String, dynamic> json) =>
      TreasureChestModel(
        message: MessageData.fromJson(json["message"]),
        data: TreasureChestBody.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class TreasureChestBody {
  TreasureChestBody({
    this.quiz,
  });

  TreasureChestQuiz? quiz;

  factory TreasureChestBody.fromJson(Map<String, dynamic> json) =>
      TreasureChestBody(
        quiz: TreasureChestQuiz.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "quiz": quiz!.toJson(),
      };
}

class TreasureChestQuiz {
  TreasureChestQuiz({
    this.header,
    this.detail,
  });

  HeaderTreasureChestQuiz? header;
  List<DetailTreasureChestQuiz>? detail;

  factory TreasureChestQuiz.fromJson(Map<String, dynamic> json) =>
      TreasureChestQuiz(
        header: HeaderTreasureChestQuiz.fromJson(json["header"]),
        detail: json["detail"] == null
            ? null
            : List<DetailTreasureChestQuiz>.from(
                json["detail"].map((x) => DetailTreasureChestQuiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class HeaderTreasureChestQuiz {
  HeaderTreasureChestQuiz({
    this.quizId,
    this.userId,
    this.eventId,
  });

  int? quizId;
  int? userId;
  int? eventId;

  factory HeaderTreasureChestQuiz.fromJson(Map<String, dynamic> json) =>
      HeaderTreasureChestQuiz(
        quizId: json["quiz_id"],
        userId: json["user_id"],
        eventId: json["event_id"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_id": quizId,
        "user_id": userId,
        "event_id": eventId,
      };
}

class DetailTreasureChestQuiz {
  DetailTreasureChestQuiz({
    this.quizDetailId,
    this.questionId,
    this.question,
    this.category,
    this.questionTypeId,
    this.text,
    this.image,
    this.video,
    this.duration,
    this.point,
    this.pointIncorrect,
    this.pointNotAnswer,
    this.source,
    this.correctAnswerCode,
    this.options,
  });

  int? quizDetailId;
  int? questionId;
  String? question;
  String? category;
  int? questionTypeId;
  String? text;
  String? image;
  String? video;
  int? duration;
  int? point;
  int? pointIncorrect;
  int? pointNotAnswer;
  String? source;
  String? correctAnswerCode;
  List<OptionTreasureChestQuiz>? options;

  factory DetailTreasureChestQuiz.fromJson(Map<String, dynamic> json) =>
      DetailTreasureChestQuiz(
        quizDetailId: json["quiz_detail_id"],
        questionId: json["question_id"],
        question: json["question"],
        category: json["category"],
        questionTypeId: json["question_type_id"],
        text: json["text"],
        image: json["image"],
        video: json["video"],
        duration: json["duration"] ?? 25,
        point: json["point"],
        pointIncorrect: json["point_incorrect"],
        pointNotAnswer: json["point_not_answer"],
        source: json["source"],
        correctAnswerCode: json["correct_answer_code"],
        options: json["options"] == null
            ? null
            : List<OptionTreasureChestQuiz>.from(json["options"]
                .map((x) => OptionTreasureChestQuiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quiz_detail_id": quizDetailId,
        "question_id": questionId,
        "question": question,
        "category": category,
        "question_type_id": questionTypeId,
        "text": text,
        "image": image,
        "video": video,
        "duration": duration ?? 25,
        "point": point,
        "point_incorrect": pointIncorrect,
        "point_not_answer": pointNotAnswer,
        "source": source,
        "correct_answer_code": correctAnswerCode,
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class OptionTreasureChestQuiz {
  OptionTreasureChestQuiz({
    this.code,
    this.answer,
  });

  String? code;
  String? answer;

  factory OptionTreasureChestQuiz.fromJson(Map<String, dynamic> json) =>
      OptionTreasureChestQuiz(
        code: json["code"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "answer": answer,
      };
}
