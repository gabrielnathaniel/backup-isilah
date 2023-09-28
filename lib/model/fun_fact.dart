import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

FunFactModel funFactModelFromJson(String str) =>
    FunFactModel.fromJson(json.decode(str));

String funFactModelToJson(FunFactModel data) => json.encode(data.toJson());

class FunFactModel {
  FunFactModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataBody? data;

  factory FunFactModel.fromJson(Map<String, dynamic> json) => FunFactModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataBody {
  DataBody({
    this.currentPage,
    this.data,
    this.total,
  });

  int? currentPage;
  List<DataFunFact>? data;
  int? total;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        currentPage: json["current_page"],
        total: json["total"],
        data: json["data"] == null
            ? null
            : List<DataFunFact>.from(
                json["data"].map((x) => DataFunFact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataFunFact {
  DataFunFact({
    this.id,
    this.title,
    this.date,
    this.duration,
    this.thumbnail,
    this.content,
    this.contentThumbnail,
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
  String? contentThumbnail;
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
  List<TagsFunFact>? tags;

  factory DataFunFact.fromJson(Map<String, dynamic> json) => DataFunFact(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        duration: json["duration"],
        thumbnail: json["thumbnail"],
        content: json["content"],
        contentThumbnail: json["content_thumbnail"],
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
            : List<TagsFunFact>.from(
                json["tags"].map((x) => TagsFunFact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "duration": duration,
        "thumbnail": thumbnail,
        "content": content,
        "content_thumbnail": contentThumbnail,
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

class TagsFunFact {
  TagsFunFact({
    this.name1,
  });

  String? name1;

  factory TagsFunFact.fromJson(Map<String, dynamic> json) => TagsFunFact(
        name1: json["name1"],
      );

  Map<String, dynamic> toJson() => {
        "name1": name1,
      };
}
