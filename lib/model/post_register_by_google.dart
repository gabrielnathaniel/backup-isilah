import 'dart:io';

class PostRegisterByGoogle {
  String? kodeReferral;
  String? fullName;
  String? username;
  String? gender;
  String? phone;
  String? email;
  String? password;
  String? confirmPassword;
  File? photo;
  String? birthdate;
  String? address;
  String? city;
  int? provinceId;
  int? regencyId;
  int? subdistrictId;
  int? urbanVillageId;
  String? postalCode;
  int? professionId;
  String? googleId;
  String? token;

  PostRegisterByGoogle(
      {this.kodeReferral,
      this.fullName,
      this.username,
      this.gender,
      this.phone,
      this.email,
      this.password,
      this.confirmPassword,
      this.photo,
      this.birthdate,
      this.city,
      this.address,
      this.provinceId,
      this.regencyId,
      this.subdistrictId,
      this.urbanVillageId,
      this.postalCode,
      this.professionId,
      this.googleId,
      this.token});
}
