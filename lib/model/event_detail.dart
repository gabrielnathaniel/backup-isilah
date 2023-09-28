import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

EventDetailModel eventDetailModelFromJson(String str) =>
    EventDetailModel.fromJson(json.decode(str));

String eventDetailModelToJson(EventDetailModel data) =>
    json.encode(data.toJson());

class EventDetailModel {
  EventDetailModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  EventDetailBody? data;
  int? status;

  factory EventDetailModel.fromJson(Map<String, dynamic> json) =>
      EventDetailModel(
        message: MessageData.fromJson(json["message"]),
        data: EventDetailBody.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class EventDetailBody {
  EventDetailBody({
    this.id,
    this.event,
    this.type,
    this.prize,
    this.description,
    this.thumbnail,
    this.startFrom,
    this.startTo,
    this.startDate,
    this.endDate,
    this.quizLimit,
    this.quizShuffle,
    this.requiredPoint,
    this.requiredExperience,
    this.joinPayPoint,
    this.joinPayExperience,
    this.answerGetExperience,
    this.answerGetPoint,
    this.loseWhenIncorrect,
    this.loseWhenIncorrectLimit,
    this.prizePoolPoint,
    this.prizePoolExp,
    this.bonusPoint,
    this.bonusPointIncorrect,
    this.bonusPointNotAnswer,
    this.bonusExperience,
    this.bonusExperienceIncorrectAnswer,
    this.bonusExperienceNotAnswer,
    this.status,
  });

  int? id;
  String? event;
  String? type;
  String? prize;
  String? description;
  String? thumbnail;
  String? startFrom;
  String? startTo;
  String? startDate;
  String? endDate;
  int? quizLimit;
  int? quizShuffle;
  int? requiredPoint;
  int? requiredExperience;
  int? joinPayPoint;
  int? joinPayExperience;
  int? answerGetExperience;
  int? answerGetPoint;
  int? loseWhenIncorrect;
  int? loseWhenIncorrectLimit;
  int? prizePoolPoint;
  int? prizePoolExp;
  int? bonusPoint;
  int? bonusPointIncorrect;
  int? bonusPointNotAnswer;
  int? bonusExperience;
  int? bonusExperienceIncorrectAnswer;
  int? bonusExperienceNotAnswer;
  int? status;

  factory EventDetailBody.fromJson(Map<String, dynamic> json) =>
      EventDetailBody(
        id: json['id'],
        event: json['event'],
        type: json['type'],
        prize: json['prize'],
        description: json['description'],
        thumbnail: json['thumbnail'],
        startFrom: json['start_from'],
        startTo: json['start_to'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        quizLimit: json['quiz_limit'],
        quizShuffle: json['quiz_shuffle'],
        requiredPoint: json['required_point'],
        requiredExperience: json['required_experience'],
        joinPayPoint: json['join_pay_point'],
        joinPayExperience: json['join_pay_experience'],
        answerGetExperience: json['answer_get_experience'],
        answerGetPoint: json['answer_get_point'],
        loseWhenIncorrect: json['lose_when_incorrect'],
        loseWhenIncorrectLimit: json['lose_when_incorrect_limit'],
        prizePoolPoint: json['prize_pool_point'],
        prizePoolExp: json['prize_pool_exp'],
        bonusPoint: json['bonus_point'],
        bonusPointIncorrect: json['bonus_point_incorrect'],
        bonusPointNotAnswer: json['bonus_point_not_answer'],
        bonusExperience: json['bonus_experience'],
        bonusExperienceIncorrectAnswer:
            json['bonus_experience_incorrect_answer'],
        bonusExperienceNotAnswer: json['bonus_experience_not_answer'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'event': event,
        'type': type,
        'prize': prize,
        'description': description,
        'thumbnail': thumbnail,
        'start_from': startFrom,
        'start_to': startTo,
        'start_date': startDate,
        'end_date': endDate,
        'quiz_limit': quizLimit,
        'quiz_shuffle': quizShuffle,
        'required_point': requiredPoint,
        'required_experience': requiredExperience,
        'join_pay_point': joinPayPoint,
        'join_pay_experience': joinPayExperience,
        'answer_get_experience': answerGetExperience,
        'answer_get_point': answerGetPoint,
        'lose_when_incorrect': loseWhenIncorrect,
        'lose_when_incorrect_limit': loseWhenIncorrectLimit,
        'prize_pool_point': prizePoolPoint,
        'prize_pool_exp': prizePoolExp,
        'bonus_point': bonusPoint,
        'bonus_point_incorrect': bonusPointIncorrect,
        'bonus_point_not_answer': bonusPointNotAnswer,
        'bonus_experience': bonusExperience,
        'bonus_experience_incorrect_answer': bonusExperienceIncorrectAnswer,
        'bonus_experience_not_answer': bonusExperienceNotAnswer,
        'status': status,
      };
}
