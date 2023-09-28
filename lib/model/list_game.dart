import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

ListGameModel listGameModelFromJson(String str) =>
    ListGameModel.fromJson(json.decode(str));

String listGameModelToJson(ListGameModel data) => json.encode(data.toJson());

class ListGameModel {
  ListGameModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  MessageData? message;
  DataBody? data;

  factory ListGameModel.fromJson(Map<String, dynamic> json) => ListGameModel(
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
  List<DataGame>? data;
  int? total;

  factory DataBody.fromJson(Map<String, dynamic> json) => DataBody(
        currentPage: json["current_page"],
        total: json["total"],
        data: json["data"] == null
            ? null
            : List<DataGame>.from(
                json["data"].map((x) => DataGame.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total": total,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataGame {
  DataGame(
      {this.gameId,
      this.game,
      this.thumbnail,
      this.description,
      this.dailyPlayLimit,
      this.dailyPlay,
      this.dailyPlayAvailable,
      this.status,
      this.levels});

  int? gameId;
  String? game;
  String? thumbnail;
  String? description;
  int? dailyPlayLimit;
  int? dailyPlay;
  int? dailyPlayAvailable;
  int? status;
  List<LevelGame>? levels;

  factory DataGame.fromJson(Map<String, dynamic> json) => DataGame(
        gameId: json["game_id"],
        game: json["game"],
        thumbnail: json["thumbnail"],
        dailyPlayLimit: json["daily_play_limit"],
        dailyPlay: json["daily_play"],
        dailyPlayAvailable: json["daily_play_available"],
        status: json["status"],
        levels: List<LevelGame>.from(
            json["levels"].map((x) => LevelGame.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "game_id": gameId,
        "game": game,
        "thumbnail": thumbnail,
        "daily_play_limit": dailyPlayLimit,
        "daily_play": dailyPlay,
        "daily_play_available": dailyPlayAvailable,
        "status": status,
        "levels": List<dynamic>.from(levels!.map((x) => x.toJson())),
      };
}

class LevelGame {
  LevelGame({
    this.gameLevelId,
    this.gameId,
    this.level,
    this.label,
    this.pointWin,
    this.pointLose,
    this.experienceWin,
    this.experienceLose,
    this.status,
  });

  int? gameLevelId;
  int? gameId;
  int? level;
  String? label;
  int? pointWin;
  int? pointLose;
  int? experienceWin;
  int? experienceLose;
  int? status;

  factory LevelGame.fromJson(Map<String, dynamic> json) => LevelGame(
        gameLevelId: json["game_level_id"],
        gameId: json["game_id"],
        level: json["level"],
        label: json["label"],
        pointWin: json["point_win"],
        pointLose: json["point_lose"],
        experienceWin: json["experience_win"],
        experienceLose: json["experience_lose"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "game_level_id": gameLevelId,
        "game_id": gameId,
        "level": level,
        "label": label,
        "point_win": pointWin,
        "point_lose": pointLose,
        "experience_win": experienceWin,
        "experience_lose": experienceLose,
        "status": status,
      };
}
