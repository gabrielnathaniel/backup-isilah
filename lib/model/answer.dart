import 'dart:convert';

AnswerModel answerModelFromJson(String str) =>
    AnswerModel.fromJson(json.decode(str));

String answerModelToJson(AnswerModel data) => json.encode(data.toJson());

class AnswerModel {
  AnswerModel({
    this.quizDetailId,
    this.questionId,
    this.answerCode,
    this.playTime,
  });

  int? quizDetailId;
  int? questionId;
  String? answerCode;
  int? playTime;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        quizDetailId: json["quiz_detail_id"],
        questionId: json["question_id"],
        answerCode: json["answer_code"],
        playTime: json["play_time"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_detail_id": quizDetailId,
        "question_id": questionId,
        "answer_code": answerCode,
        "play_time": playTime,
      };
}
