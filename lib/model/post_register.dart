import 'dart:io';

class PostRegister {
  String? kodeReferral;
  String? username;
  String? fullName;
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
  String? facebook;
  String? instagram;
  String? twitter;

  PostRegister(
      {this.kodeReferral,
      this.username,
      this.fullName,
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
      this.facebook,
      this.instagram,
      this.twitter});
}
