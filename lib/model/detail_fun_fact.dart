import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

DetailFunFactModel detailFunFactModelFromJson(String str) =>
    DetailFunFactModel.fromJson(json.decode(str));

String detailFunFactModelToJson(DetailFunFactModel data) =>
    json.encode(data.toJson());

class DetailFunFactModel {
  DetailFunFactModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DetailDataFunFact? data;

  factory DetailFunFactModel.fromJson(Map<String, dynamic> json) =>
      DetailFunFactModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: json["data"] == null
            ? null
            : DetailDataFunFact.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data == null ? null : data!.toJson(),
      };
}

class DetailDataFunFact {
  DetailDataFunFact({
    this.id,
    this.title,
    this.date,
    this.duration,
    this.thumbnail,
    this.content,
    this.url,
    this.externalLink,
    this.publishAt,
    this.publishTo,
    this.status,
    this.userId,
    this.userPhoto,
    this.fullName,
    this.bio,
    this.socmedFb,
    this.socmedIg,
    this.socmedTw,
    this.tags,
  });

  int? id;
  String? title;
  String? date;
  int? duration;
  String? thumbnail;
  String? content;
  String? url;
  String? externalLink;
  String? publishAt;
  String? publishTo;
  int? status;
  int? userId;
  String? userPhoto;
  String? fullName;
  String? bio;
  String? socmedFb;
  String? socmedIg;
  String? socmedTw;
  List<DetailTagsFunFact>? tags;

  factory DetailDataFunFact.fromJson(Map<String, dynamic> json) =>
      DetailDataFunFact(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        duration: json["duration"],
        thumbnail: json["thumbnail"],
        content: json["content"],
        url: json["url"],
        externalLink: json["external_link"],
        publishAt: json["publish_at"],
        publishTo: json["publish_to"],
        status: json["status"],
        userId: json["user_id"],
        userPhoto: json["user_photo"],
        fullName: json["full_name"],
        bio: json["bio"],
        socmedFb: json["socmed_fb"],
        socmedIg: json["socmed_ig"],
        socmedTw: json["socmed_tw"],
        tags: json["tags"] == null
            ? null
            : List<DetailTagsFunFact>.from(
                json["tags"].map((x) => DetailTagsFunFact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "duration": duration,
        "thumbnail": thumbnail,
        "content": content,
        "url": url,
        "external_link": externalLink,
        "publish_at": publishAt,
        "publish_to": publishTo,
        "status": status,
        "user_id": userId,
        "user_photo": userPhoto,
        "full_name": fullName,
        "bio": bio,
        "socmed_fb": socmedFb,
        "socmed_ig": socmedIg,
        "socmed_tw": socmedTw,
        "tags": tags == null
            ? null
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
      };
}

class DetailTagsFunFact {
  DetailTagsFunFact({
    this.name,
  });

  String? name;

  factory DetailTagsFunFact.fromJson(Map<String, dynamic> json) =>
      DetailTagsFunFact(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
