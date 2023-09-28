import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ResultQuizModel resultQuizModelFromJson(String str) =>
    ResultQuizModel.fromJson(json.decode(str));

String resultQuizModelToJson(ResultQuizModel data) =>
    json.encode(data.toJson());

class ResultQuizModel {
  ResultQuizModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  DataResultQuiz? data;
  int? status;

  factory ResultQuizModel.fromJson(Map<String, dynamic> json) =>
      ResultQuizModel(
        message: MessageData.fromJson(json["message"]),
        data: DataResultQuiz.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class DataResultQuiz {
  DataResultQuiz({
    this.header,
    this.detail,
  });

  HeaderResultQuiz? header;
  List<DetailResultQuiz>? detail;

  factory DataResultQuiz.fromJson(Map<String, dynamic> json) => DataResultQuiz(
        header: HeaderResultQuiz.fromJson(json["header"]),
        detail: json["detail"] == null
            ? null
            : List<DetailResultQuiz>.from(
                json["detail"].map((x) => DetailResultQuiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class HeaderResultQuiz {
  HeaderResultQuiz({
    this.quizId,
    this.point,
    this.experience,
    this.correct,
    this.wrong,
    this.notAnswer,
  });

  int? quizId;
  int? point;
  int? experience;
  int? correct;
  int? wrong;
  int? notAnswer;

  factory HeaderResultQuiz.fromJson(Map<String, dynamic> json) =>
      HeaderResultQuiz(
        quizId: json["quiz_id"],
        point: json["point"],
        experience: json["experience"],
        correct: json["correct"],
        wrong: json["false"],
        notAnswer: json["not_answer"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_id": quizId,
        "point": point,
        "experience": experience,
        "correct": correct,
        "false": wrong,
        "not_answer": notAnswer,
      };
}

class DetailResultQuiz {
  DetailResultQuiz({
    this.quizId,
    this.quizDetailId,
    this.questionId,
    this.question,
    this.questionTypeId,
    this.text,
    this.image,
    this.video,
    this.duration,
    this.source,
    this.correctAnswerCode,
    this.correctAnswer,
    this.answerCode,
    this.answer,
    this.answerStatus,
    this.point,
    this.experience,
  });

  int? quizId;
  int? quizDetailId;
  int? questionId;
  String? question;
  int? questionTypeId;
  String? text;
  String? image;
  String? video;
  int? duration;
  String? source;
  String? correctAnswerCode;
  String? correctAnswer;
  String? answerCode;
  String? answer;
  int? answerStatus;
  int? point;
  int? experience;

  factory DetailResultQuiz.fromJson(Map<String, dynamic> json) =>
      DetailResultQuiz(
        quizId: json["quiz_id"],
        quizDetailId: json["quiz_detail_id"],
        questionId: json["question_id"],
        question: json["question"],
        questionTypeId: json["question_type_id"],
        text: json["text"],
        image: json["image"],
        video: json["video"],
        duration: json["duration"],
        source: json["source"],
        correctAnswerCode: json["correct_answer_code"],
        correctAnswer: json["correct_answer"],
        answerCode: json["answer_code"],
        answer: json["answer"],
        answerStatus: json["answer_status"],
        point: json["point"],
        experience: json["experience"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_id": quizId,
        "quiz_detail_id": quizDetailId,
        "question_id": questionId,
        "question": question,
        "question_type_id": questionTypeId,
        "text": text,
        "image": image,
        "video": video,
        "duration": duration,
        "source": source,
        "correct_answer_code": correctAnswerCode,
        "correct_answer": correctAnswer,
        "answer_code": answerCode,
        "answer": answer,
        "answer_status": answerStatus,
        "point": point,
        "experience": experience,
      };
}
