// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.code,
    this.message,
    this.data,
    this.status,
  });

  int? code;
  MessageData? message;
  DataUser? data;
  int? status;

  factory User.fromJson(Map<String, dynamic> json) => User(
        code: json["code"],
        message: MessageData.fromJson(json["message"]),
        data: json['data'] == null ? null : DataUser.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message!.toJson(),
        "data": data == null ? null : data!.toJson(),
        "status": status,
      };
}

class DataUser {
  DataUser({
    this.token,
    this.user,
  });

  String? token;
  UserClass? user;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        token: json["token"],
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user!.toJson(),
      };
}

class UserClass {
  UserClass({
    this.id,
    this.refferalCode,
    this.username,
    this.email,
    this.point,
    this.pointPending,
    this.rankPoint,
    this.rankPointStatus,
    this.experience,
    this.rankExperience,
    this.rankExperienceStatus,
    this.experienceFrom,
    this.experienceTo,
    this.experiencePercentage,
    this.levelCode,
    this.level,
    this.levelLogo,
    this.levelToCode,
    this.levelTo,
    this.levelToLogo,
    this.photo,
    this.fullName,
    this.birthdate,
    this.gender,
    this.phone,
    this.address,
    this.urbanVillageId,
    this.urbanVillage,
    this.subdistrictId,
    this.subdistrict,
    this.regencyId,
    this.regency,
    this.provinceId,
    this.province,
    this.postalCode,
    this.professionId,
    this.profession,
    this.bio,
    this.socmedFb,
    this.socmedIg,
    this.socmedTw,
    this.friendshipRequest,
    this.deviceToken,
    this.googleLink,
    this.appleLink,
    this.shipmentDefaultId,
    this.notificationUnread,
    this.prizeWinTotal,
    this.deleteRequestAt,
    this.deletedAt,
    this.status,
    this.power,
  });

  int? id;
  String? refferalCode;
  String? username;
  String? email;
  int? point;
  int? pointPending;
  int? rankPoint;
  int? rankPointStatus;
  int? experience;
  int? rankExperience;
  int? rankExperienceStatus;
  int? experienceFrom;
  int? experienceTo;
  int? experiencePercentage;
  String? levelCode;
  String? level;
  String? levelLogo;
  String? levelToCode;
  String? levelTo;
  String? levelToLogo;
  String? photo;
  String? fullName;
  String? birthdate;
  String? gender;
  String? phone;
  String? address;
  int? urbanVillageId;
  String? urbanVillage;
  int? subdistrictId;
  String? subdistrict;
  int? regencyId;
  String? regency;
  int? provinceId;
  String? province;
  String? postalCode;
  int? professionId;
  String? profession;
  String? bio;
  String? socmedFb;
  String? socmedIg;
  String? socmedTw;
  int? friendshipRequest;
  String? deviceToken;
  int? googleLink;
  int? appleLink;
  int? shipmentDefaultId;
  int? notificationUnread;
  int? prizeWinTotal;
  String? deleteRequestAt;
  String? deletedAt;
  int? status;
  PowerUser? power;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        refferalCode: json["refferal_code"],
        username: json["username"],
        email: json["email"],
        point: json["point"],
        pointPending: json["point_pending"],
        rankPoint: json["rank_point"],
        rankPointStatus: json["rank_point_status"],
        experience: json["experience"],
        rankExperience: json["rank_experience"],
        rankExperienceStatus: json["rank_experience_status"],
        experienceFrom: json["experience_from"],
        experienceTo: json["experience_to"],
        experiencePercentage: json["experience_percentage"],
        levelCode: json["level_code"],
        level: json["level"],
        levelLogo: json["level_logo"],
        levelToCode: json["level_to_code"],
        levelTo: json["level_to"],
        levelToLogo: json["level_to_logo"],
        photo: json["photo"],
        fullName: json["full_name"],
        birthdate: json["birthdate"],
        gender: json["gender"],
        phone: json["phone"],
        address: json["address"],
        urbanVillageId: json["urban_village_id"],
        urbanVillage: json["urban_village"],
        subdistrictId: json["subdistrict_id"],
        subdistrict: json["subdistrict"],
        regencyId: json["regency_id"],
        regency: json["regency"],
        provinceId: json["province_id"],
        province: json["province"],
        postalCode: json["postal_code"],
        professionId: json["profession_id"],
        profession: json["profession"],
        bio: json["bio"],
        socmedFb: json["socmed_fb"],
        socmedIg: json["socmed_ig"],
        socmedTw: json["socmed_tw"],
        friendshipRequest: json["friendship_request"],
        deviceToken: json["device_token"],
        googleLink: json["google_link"],
        appleLink: json["apple_link"],
        shipmentDefaultId: json["shipment_default_id"],
        notificationUnread: json["notification_unread"],
        prizeWinTotal: json["prize_win_total"],
        deleteRequestAt: json["delete_request_at"],
        deletedAt: json["deleted_at"],
        status: json["status"],
        power: json["power"] == null ? null : PowerUser.fromJson(json["power"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refferal_code": refferalCode,
        "username": username,
        "email": email,
        "point": point,
        "point_pending": pointPending,
        "rank_point": rankPoint,
        "rank_point_status": rankPointStatus,
        "experience": experience,
        "rank_experience": rankExperience,
        "rank_experience_status": rankExperienceStatus,
        "experience_from": experienceFrom,
        "experience_to": experienceTo,
        "experience_percentage": experiencePercentage,
        "level_code": levelCode,
        "level": level,
        "level_logo": levelLogo,
        "level_to_code": levelToCode,
        "level_to": levelTo,
        "level_to_logo": levelToLogo,
        "photo": photo,
        "full_name": fullName,
        "birthdate": birthdate,
        "gender": gender,
        "phone": phone,
        "address": address,
        "urban_village_id": urbanVillageId,
        "urban_village": urbanVillage,
        "subdistrict_id": subdistrictId,
        "subdistrict": subdistrict,
        "regency_id": regencyId,
        "regency": regency,
        "province_id": provinceId,
        "province": province,
        "postal_code": postalCode,
        "profession_id": professionId,
        "profession": profession,
        "bio": bio,
        "socmed_fb": socmedFb,
        "socmed_ig": socmedIg,
        "socmed_tw": socmedTw,
        "friendship_request": friendshipRequest,
        "device_token": deviceToken,
        "google_link": googleLink,
        "apple_link": appleLink,
        "shipment_default_id": shipmentDefaultId,
        "notification_unread": notificationUnread,
        "prize_win_total": prizeWinTotal,
        "delete_request_at": deleteRequestAt,
        "deleted_at": deletedAt,
        "status": status,
        "power": power == null ? null : power!.toJson(),
      };
}

class PowerUser {
  PowerUser({
    this.header,
    this.average,
    this.detail,
  });

  HeaderUser? header;
  List<AverageUser>? average;
  List<DetailUser>? detail;

  factory PowerUser.fromJson(Map<String, dynamic> json) => PowerUser(
        header: HeaderUser.fromJson(json["header"]),
        average: List<AverageUser>.from(
            json["average"].map((x) => AverageUser.fromJson(x))),
        detail: List<DetailUser>.from(
            json["detail"].map((x) => DetailUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header!.toJson(),
        "average": List<dynamic>.from(average!.map((x) => x.toJson())),
        "detail": List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class AverageUser {
  AverageUser({
    this.categoryId,
    this.category,
    this.description,
    this.power,
  });

  int? categoryId;
  String? category;
  String? description;
  int? power;

  factory AverageUser.fromJson(Map<String, dynamic> json) => AverageUser(
        categoryId: json["category_id"],
        category: json["category"],
        description: json["description"],
        power: json["power"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category": category,
        "description": description,
        "power": power,
      };
}

class DetailUser {
  DetailUser({
    this.categoryId,
    this.category,
    this.description,
    this.totalAnswer,
    this.totalCorrectAnswer,
    this.power,
  });

  int? categoryId;
  String? category;
  String? description;
  int? totalAnswer;
  String? totalCorrectAnswer;
  String? power;

  factory DetailUser.fromJson(Map<String, dynamic> json) => DetailUser(
        categoryId: json["category_id"],
        category: json["category"],
        description: json["description"],
        totalAnswer: json["total_answer"],
        totalCorrectAnswer: json["total_correct_answer"],
        power: json["power"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category": category,
        "description": description,
        "total_answer": totalAnswer,
        "total_correct_answer": totalCorrectAnswer,
        "power": power,
      };
}

class HeaderUser {
  HeaderUser({
    this.playing,
    this.averagePlayingTime,
  });

  int? playing;
  String? averagePlayingTime;

  factory HeaderUser.fromJson(Map<String, dynamic> json) => HeaderUser(
        playing: json["playing"],
        averagePlayingTime: json["average_playing_time"],
      );

  Map<String, dynamic> toJson() => {
        "playing": playing,
        "average_playing_time": averagePlayingTime,
      };
}

class ShipmentUser {
  ShipmentUser({
    this.id,
    this.userId,
    this.defaultShipment,
    this.label,
    this.receiverName,
    this.gender,
    this.phone,
    this.address,
    this.postalCode,
  });

  int? id;
  int? userId;
  int? defaultShipment;
  String? label;
  String? receiverName;
  String? gender;
  String? phone;
  String? address;
  dynamic postalCode;

  factory ShipmentUser.fromJson(Map<String, dynamic> json) => ShipmentUser(
        id: json["id"],
        userId: json["user_id"],
        defaultShipment: json["default"],
        label: json["label"],
        receiverName: json["receiver_name"],
        gender: json["gender"],
        phone: json["phone"],
        address: json["address"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "default": defaultShipment,
        "label": label,
        "receiver_name": receiverName,
        "gender": gender,
        "phone": phone,
        "address": address,
        "postal_code": postalCode,
      };
}
