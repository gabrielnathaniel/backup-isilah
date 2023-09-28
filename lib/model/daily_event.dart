import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

DailyEventModel dailyEventModelFromJson(String str) =>
    DailyEventModel.fromJson(json.decode(str));

String dailyEventModelToJson(DailyEventModel data) =>
    json.encode(data.toJson());

class DailyEventModel {
  DailyEventModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  DataDailyEvent? data;
  int? status;

  factory DailyEventModel.fromJson(Map<String, dynamic> json) =>
      DailyEventModel(
        message: MessageData.fromJson(json["message"]),
        data: DataDailyEvent.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class DataDailyEvent {
  DataDailyEvent({
    this.current,
    this.next,
  });

  CurrentDailyEvent? current;
  CurrentDailyEvent? next;

  factory DataDailyEvent.fromJson(Map<String, dynamic> json) => DataDailyEvent(
        current: json["current"] == null
            ? null
            : CurrentDailyEvent.fromJson(json["current"]),
        next: json["next"] == null
            ? null
            : CurrentDailyEvent.fromJson(json["next"]),
      );

  Map<String, dynamic> toJson() => {
        "current": current!.toJson(),
        "next": next!.toJson(),
      };
}

class CurrentDailyEvent {
  CurrentDailyEvent({
    this.periode,
    this.eventId,
    this.event,
    this.eventDate,
    this.description,
    this.startFrom,
    this.startTo,
    this.statusPlay,
    this.randomWord,
  });

  String? periode;
  int? eventId;
  String? event;
  String? eventDate;
  String? description;
  String? startFrom;
  String? startTo;
  int? statusPlay;
  String? randomWord;

  factory CurrentDailyEvent.fromJson(Map<String, dynamic> json) =>
      CurrentDailyEvent(
        periode: json["periode"],
        eventId: json["event_id"],
        event: json['`event`'],
        eventDate: json['event_date'],
        description: json["description"],
        startFrom: json["start_from"],
        startTo: json["start_to"],
        statusPlay: json["status_play"],
        randomWord: json["random_word"],
      );

  Map<String, dynamic> toJson() => {
        "periode": periode,
        "event_id": eventId,
        '`event`': event,
        'event_date': eventDate,
        "description": description,
        "start_from": startFrom,
        "start_to": startTo,
        "status_play": statusPlay,
        "random_word": randomWord,
      };
}
