import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

PlayQuizModel playQuizModelFromJson(String str) =>
    PlayQuizModel.fromJson(json.decode(str));

String playQuizModelToJson(PlayQuizModel data) => json.encode(data.toJson());

class PlayQuizModel {
  PlayQuizModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  DataBody? data;
  int? status;

  factory PlayQuizModel.fromJson(Map<String, dynamic> json) => PlayQuizModel(
        message: MessageData.fromJson(json["message"]),
        data: DataBody.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class DataBody {
  DataBody({
    this.quiz,
  });

  DataQuiz? quiz;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        quiz: DataQuiz.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "quiz": quiz!.toJson(),
      };
}

class DataQuiz {
  DataQuiz({
    this.header,
    this.detail,
  });

  HeaderQuiz? header;
  List<DetailQuiz>? detail;

  factory DataQuiz.fromJson(Map<String, dynamic> json) => DataQuiz(
        header: HeaderQuiz.fromJson(json["header"]),
        detail: json["detail"] == null
            ? null
            : List<DetailQuiz>.from(
                json["detail"].map((x) => DetailQuiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class HeaderQuiz {
  HeaderQuiz({
    this.quizId,
    this.userId,
    this.eventId,
  });

  int? quizId;
  int? userId;
  int? eventId;

  factory HeaderQuiz.fromJson(Map<String, dynamic> json) => HeaderQuiz(
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

class DetailQuiz {
  DetailQuiz({
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
  List<OptionQuiz>? options;

  factory DetailQuiz.fromJson(Map<String, dynamic> json) => DetailQuiz(
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
            : List<OptionQuiz>.from(
                json["options"].map((x) => OptionQuiz.fromJson(x))),
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

class OptionQuiz {
  OptionQuiz({
    this.code,
    this.answer,
  });

  String? code;
  String? answer;

  factory OptionQuiz.fromJson(Map<String, dynamic> json) => OptionQuiz(
        code: json["code"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "answer": answer,
      };
}
