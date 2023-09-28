import 'dart:convert';

import 'package:isilahtitiktitik/model/message.dart';

SingleUserModel singleUserModelFromJson(String str) =>
    SingleUserModel.fromJson(json.decode(str));

String singleUserModelToJson(SingleUserModel data) =>
    json.encode(data.toJson());

class SingleUserModel {
  SingleUserModel({
    this.message,
    this.data,
    this.status,
  });

  MessageData? message;
  SingleUserDataClass? data;
  int? status;

  factory SingleUserModel.fromJson(Map<String, dynamic> json) =>
      SingleUserModel(
        message: MessageData.fromJson(json["message"]),
        data: SingleUserDataClass.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "data": data!.toJson(),
        "status": status,
      };
}

class SingleUserDataClass {
  SingleUserDataClass({
    this.id,
    this.refferalCode,
    this.username,
    this.email,
    this.point,
    this.rank,
    this.rankStatus,
    this.experience,
    this.experienceFrom,
    this.experienceTo,
    this.experiencePercentage,
    this.level,
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
  });

  int? id;
  String? refferalCode;
  String? username;
  String? email;
  int? point;
  int? rank;
  int? rankStatus;
  int? experience;
  int? experienceFrom;
  int? experienceTo;
  int? experiencePercentage;
  String? level;
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

  factory SingleUserDataClass.fromJson(Map<String, dynamic> json) =>
      SingleUserDataClass(
        id: json["id"],
        refferalCode: json["refferal_code"],
        username: json["username"],
        email: json["email"],
        point: json["point"],
        rank: json["rank"],
        rankStatus: json["rank_status"],
        experience: json["experience"],
        experienceFrom: json["experience_from"],
        experienceTo: json["experience_to"],
        experiencePercentage: json["experience_percentage"],
        level: json["level"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refferal_code": refferalCode,
        "username": username,
        "email": email,
        "point": point,
        "rank": rank,
        "rank_status": rankStatus,
        "experience": experience,
        "experience_from": experienceFrom,
        "experience_to": experienceTo,
        "experience_percentage": experiencePercentage,
        "level": level,
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
      };
}
