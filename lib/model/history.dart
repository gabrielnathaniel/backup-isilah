import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

HistoryModel historyModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataHistory? data;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        status: json["status"],
        message: MessageData.fromJson(json["message"]),
        data: DataHistory.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message!.toJson(),
        "data": data!.toJson(),
      };
}

class DataHistory {
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

  DataHistory(
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

  factory DataHistory.fromJson(Map<String, dynamic> json) => DataHistory(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? null
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
  int? transactionId;
  String? code;
  String? source;
  int? sourceId;
  String? date;
  int? amount;
  String? notes;
  int? status;

  Data(
      {this.transactionId,
      this.code,
      this.source,
      this.sourceId,
      this.date,
      this.amount,
      this.notes,
      this.status});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionId: json['transaction_id'],
        code: json['code'],
        source: json['source'],
        sourceId: json['source_id'],
        date: json['date'],
        amount: json['amount'],
        notes: json['notes'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "code": code,
        "source": source,
        "source_id": sourceId,
        "date": date,
        "amount": amount,
        "notes": notes,
        "status": status,
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
