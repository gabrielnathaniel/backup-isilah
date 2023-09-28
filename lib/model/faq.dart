import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  FaqModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataFaq? data;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataFaq.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataFaq {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  String? prevPageUrl;
  int? to;
  int? total;

  DataFaq(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.prevPageUrl,
      this.to,
      this.total});

  factory DataFaq.fromJson(Map<String, dynamic> json) => DataFaq(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? null
            : List<Links>.from(json["links"].map((x) => Links.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "firstPageUrl": firstPageUrl,
        "from": from,
        "lastPage": lastPage,
        "lastPageUrl": lastPageUrl,
        "links": links == null
            ? null
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "nextPageUrl": nextPageUrl,
        "path": path,
        "prevPageUrl": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Data {
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
  List<Tags>? tags;
  int? userId;
  String? userPhoto;
  String? fullName;
  String? bio;
  String? sosmedFb;
  String? sosmedIg;
  String? sosmedTw;

  Data(
      {this.id,
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
      this.tags,
      this.userId,
      this.userPhoto,
      this.fullName,
      this.bio,
      this.sosmedFb,
      this.sosmedIg,
      this.sosmedTw});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        title: json['title'],
        date: json['date'],
        duration: json['duration'],
        thumbnail: json['thumbnail'],
        content: json['content'],
        contentThumbnail: json['content_thumnail'],
        url: json['url'],
        externalLink: json['external_link'],
        publishAt: json['publish_at'],
        publishTo: json['publish_to'],
        status: json['status'],
        tags: json["tags"] == null
            ? null
            : List<Tags>.from(json["tags"].map((x) => Tags.fromJson(x))),
        userId: json['user_id'],
        userPhoto: json['user_photo'],
        fullName: json['full_name'],
        bio: json['bio'],
        sosmedFb: json['sosmed_fb'],
        sosmedIg: json['sosmed_ig'],
        sosmedTw: json['sosmed_tw'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'duration': duration,
        'thumbnail': thumbnail,
        'content': content,
        'content_thumbnail': contentThumbnail,
        'url': url,
        'external_link': externalLink,
        'publish_at': publishAt,
        'publish_to': publishTo,
        'status': status,
        'tags': tags == null
            ? null
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        'user_id': userId,
        'user_photo': userPhoto,
        'full_name': fullName,
        'bio': bio,
        'sosmed_fb': sosmedFb,
        'sosmed_ig': sosmedIg,
        'sosmed_tw': sosmedTw,
      };
}

class Tags {
  String? name;

  Tags({
    this.name,
  });

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        url: json['url'],
        label: json['label'],
        active: json['active'],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
