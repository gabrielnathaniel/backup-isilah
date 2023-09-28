import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/utils/enc.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<User?> login(String email, String password);
  Future<User?> loginWithGoogle(String email, String googleId, String token);
  Future<User?> loadUserAuth();
  Future<User?> loadSingleUser();
  Future<bool?> isLoggedIn();
  Future<bool?> isOnboardVisited();
  void logout();
  User? currentUser;
}

class Auth implements BaseAuth {
  @override
  User? currentUser;
  bool? _isVisited;

  @override
  Future<bool?> isOnboardVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isVisited = prefs.getBool("visited");
    _isVisited ??= false;
    prefs.setBool("visited", false);
    return _isVisited;
  }

  @override
  Future<bool> isLoggedIn() async {
    bool isLoaded = false;
    User? userAuth = await loadUserAuth();
    isLoaded = userAuth == null ? false : true;
    return isLoaded;
  }

  @override
  Future<User?> loadUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("id") == null) {
      currentUser = null;
    } else {
      User userAuth = User(
          data: DataUser(
              token: prefs.getString('token'),
              user: UserClass(
                id: prefs.getInt('id'),
                refferalCode: prefs.getString('refferalCode'),
                username: prefs.getString('username'),
                email: prefs.getString('email'),
                point: prefs.getInt('point'),
                rankPoint: prefs.getInt('rankPoint'),
                rankPointStatus: prefs.getInt('rankPointStatus'),
                experience: prefs.getInt('experience'),
                rankExperience: prefs.getInt('rankExperience'),
                rankExperienceStatus: prefs.getInt('rankExperienceStatus'),
                experienceFrom: prefs.getInt('experienceFrom'),
                experienceTo: prefs.getInt('experienceTo'),
                experiencePercentage: prefs.getInt('experiencePercentage'),
                level: prefs.getString('level'),
                levelLogo: prefs.getString('levelLogo'),
                photo: prefs.getString('photo'),
                fullName: prefs.getString('fullName'),
                birthdate: prefs.getString('birthdate'),
                gender: prefs.getString('gender'),
                phone: prefs.getString('phone'),
                address: prefs.getString('address'),
                urbanVillageId: prefs.getInt('urbanVillageId'),
                urbanVillage: prefs.getString('urbanVillage'),
                subdistrictId: prefs.getInt('subdistrictId'),
                subdistrict: prefs.getString('subdistrict'),
                regencyId: prefs.getInt('regencyId'),
                regency: prefs.getString('regency'),
                provinceId: prefs.getInt('provinceId'),
                province: prefs.getString('province'),
                postalCode: prefs.getString('postalCode'),
                professionId: prefs.getInt('professionId'),
                profession: prefs.getString('profession'),
                bio: prefs.getString('bio'),
                socmedFb: prefs.getString('socmedFb'),
                socmedIg: prefs.getString('socmedIg'),
                socmedTw: prefs.getString('socmedTw'),
                friendshipRequest: prefs.getInt('friendshipRequest'),
                deviceToken: prefs.getString('deviceToken'),
                googleLink: prefs.getInt('googleLink'),
                appleLink: prefs.getInt('appleLink'),
                shipmentDefaultId: prefs.getInt('shipmentDefaultId'),
                notificationUnread: prefs.getInt('notificationUnread'),
                deleteRequestAt: prefs.getString('deleteRequestAt'),
                deletedAt: prefs.getString('deletedAt'),
                status: prefs.getInt('status'),
              )));
      currentUser = userAuth;
    }
    return currentUser;
  }

  @override
  Future<User?> login(String email, String password) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/login";
    try {
      Response res = await dio.post(url,
          data: {"email": email, "password": password},
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));

      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      _deleteUserData();
      currentUser = null;
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(dioError: err, errorFrom: "login")
            .errorMessage();
      }
    }
    return currentUser;
  }

  @override
  Future<User?> loginWithGoogle(
      String email, String googleId, String token) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/login_google";
    try {
      Response res = await dio.post(url,
          data: {"email": email, "google_id": googleId, "token": token},
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      _deleteUserData();
      currentUser = null;
      throw err.response!.data;
    }
    return currentUser;
  }

  @override
  Future<User?> loadSingleUser() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/profile";
    try {
      Response res = await dio.post(url,
          options: Options(headers: {
            "Authorization": "Bearer ${currentUser!.data!.token}",
            "isilah-key": apiKey,
            "release": timestamp
          }));
      Logger().d(res.data);
      final User userModel = User.fromJson(res.data);
      currentUser = userModel;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response!.statusCode == 401) {
        _deleteUserData();
        currentUser = null;
      }

      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "loadSingleUser")
          .errorMessage();
    }
    return currentUser;
  }

  void _writeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("visited", false);
    if (currentUser!.data != null) {
      prefs.setString("token", currentUser!.data!.token!);
      prefs.setInt("id", currentUser!.data!.user!.id!);
      prefs.setString("refferalCode", currentUser!.data!.user!.refferalCode!);
      prefs.setString("username", currentUser!.data!.user!.username!);
      prefs.setString("email", currentUser!.data!.user!.email ?? "");
      prefs.setInt("point", currentUser!.data!.user!.point!);
      prefs.setInt("rankPoint", currentUser!.data!.user!.rankPoint!);
      prefs.setInt(
          "rankPointStatus", currentUser!.data!.user!.rankPointStatus!);
      prefs.setInt("experience", currentUser!.data!.user!.experience!);
      prefs.setInt("rankExperience", currentUser!.data!.user!.rankExperience!);
      prefs.setInt("rankExperienceStatus",
          currentUser!.data!.user!.rankExperienceStatus!);
      prefs.setInt("experienceFrom", currentUser!.data!.user!.experienceFrom!);
      prefs.setInt("experienceTo", currentUser!.data!.user!.experienceTo!);
      prefs.setInt("experiencePercentage",
          currentUser!.data!.user!.experiencePercentage!);
      prefs.setString("level", currentUser!.data!.user!.level!);
      prefs.setString("levelLogo", currentUser!.data!.user!.levelLogo!);
      prefs.setString(
          "photo",
          currentUser!.data!.user!.photo == null
              ? ""
              : currentUser!.data!.user!.photo!);
      prefs.setString("fullName", currentUser!.data!.user!.fullName!);
      prefs.setString(
          "birthdate",
          currentUser!.data!.user!.birthdate == null
              ? ""
              : currentUser!.data!.user!.birthdate!);
      prefs.setString(
          "gender",
          currentUser!.data!.user!.gender == null
              ? ""
              : currentUser!.data!.user!.gender!);
      prefs.setString(
          "phone",
          currentUser!.data!.user!.phone == null
              ? ""
              : currentUser!.data!.user!.phone!);
      prefs.setString(
          "address",
          currentUser!.data!.user!.address == null
              ? ""
              : currentUser!.data!.user!.address!);
      prefs.setInt(
          "urbanVillageId",
          currentUser!.data!.user!.urbanVillageId == null
              ? 0
              : currentUser!.data!.user!.urbanVillageId!);
      prefs.setString(
          "urbanVillage",
          currentUser!.data!.user!.urbanVillage == null
              ? ""
              : currentUser!.data!.user!.urbanVillage!);
      prefs.setInt(
          "subdistrictId",
          currentUser!.data!.user!.subdistrictId == null
              ? 0
              : currentUser!.data!.user!.subdistrictId!);
      prefs.setString(
          "subdistrict",
          currentUser!.data!.user!.subdistrict == null
              ? ""
              : currentUser!.data!.user!.subdistrict!);
      prefs.setInt(
          "regencyId",
          currentUser!.data!.user!.regencyId == null
              ? 0
              : currentUser!.data!.user!.regencyId!);
      prefs.setString(
          "regency",
          currentUser!.data!.user!.regency == null
              ? ""
              : currentUser!.data!.user!.regency!);
      prefs.setInt(
          "provinceId",
          currentUser!.data!.user!.provinceId == null
              ? 0
              : currentUser!.data!.user!.provinceId!);
      prefs.setString(
          "province",
          currentUser!.data!.user!.province == null
              ? ""
              : currentUser!.data!.user!.province!);
      prefs.setString(
          "postalCode",
          currentUser!.data!.user!.postalCode == null
              ? ""
              : currentUser!.data!.user!.postalCode!);
      prefs.setInt("professionId", currentUser!.data!.user!.professionId!);
      prefs.setString(
          "profession",
          currentUser!.data!.user!.profession == null
              ? ""
              : currentUser!.data!.user!.profession!);
      prefs.setString(
          "bio",
          currentUser!.data!.user!.bio == null
              ? ""
              : currentUser!.data!.user!.bio!);
      prefs.setString(
          "socmedFb",
          currentUser!.data!.user!.socmedFb == null
              ? ""
              : currentUser!.data!.user!.socmedFb!);
      prefs.setString(
          "socmedIg",
          currentUser!.data!.user!.socmedIg == null
              ? ""
              : currentUser!.data!.user!.socmedIg!);
      prefs.setString(
          "socmedTw",
          currentUser!.data!.user!.socmedTw == null
              ? ""
              : currentUser!.data!.user!.socmedTw!);
      prefs.setInt(
          "friendshipRequest",
          currentUser!.data!.user!.friendshipRequest == null
              ? 0
              : currentUser!.data!.user!.friendshipRequest!);
      prefs.setString(
          "deviceToken",
          currentUser!.data!.user!.deviceToken == null
              ? ""
              : currentUser!.data!.user!.deviceToken!);
      prefs.setInt(
          "googleLink",
          currentUser!.data!.user!.googleLink == null
              ? 0
              : currentUser!.data!.user!.googleLink!);
      prefs.setInt(
          "appleLink",
          currentUser!.data!.user!.appleLink == null
              ? 0
              : currentUser!.data!.user!.appleLink!);
      prefs.setInt(
          "shipmentDefaultId",
          currentUser!.data!.user!.shipmentDefaultId == null
              ? 0
              : currentUser!.data!.user!.shipmentDefaultId!);
      prefs.setInt(
          "notificationUnread",
          currentUser!.data!.user!.notificationUnread == null
              ? 0
              : currentUser!.data!.user!.notificationUnread!);
      prefs.setInt(
          "prizeWinTotal",
          currentUser!.data!.user!.prizeWinTotal == null
              ? 0
              : currentUser!.data!.user!.prizeWinTotal!);
      prefs.setString(
          "deleteRequestAt",
          currentUser!.data!.user!.deleteRequestAt == null
              ? ""
              : currentUser!.data!.user!.deleteRequestAt!);
      prefs.setString(
          "deletedAt",
          currentUser!.data!.user!.deletedAt == null
              ? ""
              : currentUser!.data!.user!.deletedAt!);
      prefs.setInt(
          "status",
          currentUser!.data!.user!.status == null
              ? 0
              : currentUser!.data!.user!.status!);
    }
  }

  void _deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("visited", false);
    prefs.setBool("withGoogle", false);
    prefs.remove("token");
    prefs.remove("id");
    prefs.remove("refferalCode");
    prefs.remove("username");
    prefs.remove("email");
    prefs.remove("point");
    prefs.remove("rankPoint");
    prefs.remove("rankPointStatus");
    prefs.remove("experience");
    prefs.remove("rankExperience");
    prefs.remove("rankExperienceStatus");
    prefs.remove("experienceFrom");
    prefs.remove("experienceTo");
    prefs.remove("experiencePercentage");
    prefs.remove("level");
    prefs.remove("levelLogo");
    prefs.remove("photo");
    prefs.remove("fullName");
    prefs.remove("birthdate");
    prefs.remove("gender");
    prefs.remove("phone");
    prefs.remove("address");
    prefs.remove("urbanVillageId");
    prefs.remove("urbanVillage");
    prefs.remove("subdistrictId");
    prefs.remove("subdistrict");
    prefs.remove("regencyId");
    prefs.remove("regency");
    prefs.remove("provinceId");
    prefs.remove("province");
    prefs.remove("postalCode");
    prefs.remove("professionId");
    prefs.remove("profession");
    prefs.remove("bio");
    prefs.remove("socmedFb");
    prefs.remove("socmedIg");
    prefs.remove("socmedTw");
    prefs.remove("friendshipRequest");
    prefs.remove("deviceToken");
    prefs.remove("googleLink");
    prefs.remove("appleLink");
    prefs.remove("shipmentDefaultId");
    prefs.remove("notificationUnread");
    prefs.remove("deleteRequestAt");
    prefs.remove("deletedAt");
    prefs.remove("status");

    currentUser = null;
  }

  @override
  void logout() {
    _deleteUserData();
  }

  Future fetchLogout() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    String url = "$baseUrl/logout";
    try {
      Response res = await dio.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "fetchLogout")
            .errorMessage();
      }
    }
  }

  Future postRegisterOne(
      String referralCode,
      String fullName,
      String gender,
      String birthdate,
      String address,
      int provinceId,
      int regencyId,
      int subdistrictId,
      int urbanVillageId,
      String postalCode,
      int professionId,
      String facebook,
      String instagram,
      String twitter) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_one";
    FormData formData = FormData.fromMap({
      "refferal_code": referralCode,
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "province_id": provinceId,
      "regency_id": regencyId,
      "subdistrict_id": subdistrictId,
      "urban_village_id": urbanVillageId,
      "postal_code": postalCode,
      "profession_id": professionId,
      "socmed_fb": facebook,
      "socmed_ig": instagram,
      "socmed_tw": twitter,
    });

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterOne")
            .errorMessage();
      }
    }
  }

  Future postRegisterTwo(String username, String phone, String email,
      String password, String confirmPassword,
      [File? photo]) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_two";
    Map<String, dynamic> data = {
      "username": username,
      "phone": phone,
      "password": password,
      "password_repeat": confirmPassword,
    };
    if (photo != null) {
      String fileName = photo.path.split('/').last;
      data.addAll({
        "photo": await MultipartFile.fromFile(photo.path, filename: fileName)
      });
    }

    if (email.trim().isNotEmpty) {
      data.addAll({
        "email": email,
      });
    }
    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterTwo")
            .errorMessage();
      }
    }
  }

  Future postRegisterResendOTP(String email) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_resend";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterResendOTP")
            .errorMessage();
      }
    }
  }

  Future postRegisterVerifyOTP(String email, String otp) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_three";
    Map<String, dynamic> data = {
      "email": email,
      "otp": otp,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterVerifyOTP")
            .errorMessage();
      }
    }
  }

  Future<User?> postRegisterFinishing(
      String referralCode,
      String username,
      String fullName,
      String gender,
      String birthdate,
      String address,
      int provinceId,
      int regencyId,
      int subdistrictId,
      int urbanVillageId,
      String postalCode,
      int professionId,
      String facebook,
      String instagram,
      String twitter,
      String phone,
      String email,
      String password,
      String confirmPassword,
      File photo,
      String otp) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_finish";
    String fileName = photo.path.split('/').last;
    Map<String, dynamic> data = {
      "refferal_code": referralCode,
      "username": username,
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "province_id": provinceId,
      "regency_id": regencyId,
      "subdistrict_id": subdistrictId,
      "urban_village_id": urbanVillageId,
      "profession_id": professionId,
      "phone": phone,
      "password": password,
      "password_repeat": confirmPassword,
      "photo": await MultipartFile.fromFile(photo.path, filename: fileName),
    };

    if (otp.trim().isNotEmpty) {
      data.addAll({"otp": otp});
    }

    if (email.trim().isNotEmpty) {
      data.addAll({"email": email});
    }
    if (facebook.trim().isNotEmpty) {
      data.addAll({"socmed_fb": facebook});
    }
    if (instagram.trim().isNotEmpty) {
      data.addAll({"socmed_ig": instagram});
    }
    if (twitter.trim().isNotEmpty) {
      data.addAll({"socmed_tw": twitter});
    }
    if (postalCode.trim().isNotEmpty) {
      data.addAll({"postal_code": postalCode});
    }

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      Logger().d("response register:");
      Logger().d(res.data);
      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterFinishing")
            .errorMessage();
      }
    }
    return currentUser;
  }

  Future<User?> putProfile(
    String fullName,
    String gender,
    String birthdate,
    String address,
    int provinceId,
    int regencyId,
    int subdistrictId,
    int urbanVillageId,
    String postalCode,
    int professionId, [
    XFile? photo,
    String facebook = '',
    String instagram = '',
    String twitter = '',
  ]) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/profile_update";
    Map<String, dynamic> data = {
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "province_id": provinceId,
      "regency_id": regencyId,
      "subdistrict_id": subdistrictId,
      "urban_village_id": urbanVillageId,
      "postal_code": postalCode,
      "profession_id": professionId,
    };
    if (photo != null) {
      File foto = File(photo.path);
      String fileName = foto.path.split('/').last;
      data.addAll({
        "photo": await MultipartFile.fromFile(foto.path, filename: fileName)
      });
    }

    if (facebook.trim().isNotEmpty) {
      data.addAll({
        "socmed_fb": facebook,
      });
    }

    if (instagram.trim().isNotEmpty) {
      data.addAll({
        "socmed_ig": instagram,
      });
    }

    if (twitter.trim().isNotEmpty) {
      data.addAll({
        "socmed_tw": twitter,
      });
    }

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      if (res.data['status'] == 1) {
        User user = User.fromJson(res.data);
        currentUser = user;
        _writeUserData();
      } else {
        User user = User.fromJson(res.data);
        return user;
      }
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(dioError: err, errorFrom: "putProfile")
            .errorMessage();
      }
    }
    return currentUser;
  }

  Future<User> changePassword(
      String oldPassowrd, String newPassword, String confirmPassowrd) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/change_password";
    Map<String, dynamic> data = {
      "password": newPassword,
      "password_repeat": confirmPassowrd,
      "password_old": oldPassowrd,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "changePassword")
            .errorMessage();
      }
    }
  }

  Future forgotPassword(String email) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_step_one";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "forgotPassword")
            .errorMessage();
      }
    }
  }

  Future forgotPasswordResendOTP(String email) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_resend";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "forgotPasswordResendOTP")
            .errorMessage();
      }
    }
  }

  Future forgotPasswordVerifyOTP(String email, String otp) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_step_two";
    Map<String, dynamic> data = {
      "email": email,
      "otp": otp,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "forgotPasswordVerifyOTP")
            .errorMessage();
      }
    }
  }

  Future<User?> forgotPasswordFinishing(String email, String otp,
      String newPassword, String confirmPassword) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_finish";
    Map<String, dynamic> data = {
      "email": email,
      "otp": otp,
      "password": newPassword,
      "password_repeat": confirmPassword,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(url,
          data: formData,
          options:
              Options(headers: {"isilah-key": apiKey, "release": timestamp}));
      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "forgotPasswordFinishing")
            .errorMessage();
      }
    }
    return currentUser;
  }

  Future<User> fetchOverview() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/profile";
    try {
      Response res = await dio.post(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      Logger().d(res.data);
      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> postReferralUpdate(String referralCode) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    String url = "$baseUrl/my/profile_update_refferal";
    try {
      Response res = await dio.post(
        url,
        data: {"refferal_code": referralCode},
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );

      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postReferralUpdate")
            .errorMessage();
      }
    }
  }

  Future postRegisterGoogleOne(
      String referralCode,
      String fullName,
      String gender,
      String birthdate,
      String address,
      int provinceId,
      int regencyId,
      int subdistrictId,
      int urbanVillageId,
      String postalCode,
      int professionId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_one";
    FormData formData = FormData.fromMap({
      "refferal_code": referralCode,
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "province_id": provinceId,
      "regency_id": regencyId,
      "subdistrict_id": subdistrictId,
      "urban_village_id": urbanVillageId,
      "postal_code": postalCode,
      "profession_id": professionId
    });

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterGoogleOne")
            .errorMessage();
      }
    }
  }

  Future postRegisterGoogleTwo(String phone, String email, String password,
      String confirmPassword, String googleId, String token,
      [File? photo]) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_google_step_two";

    Map<String, dynamic> data = {
      "phone": phone,
      "password": password,
      "password_repeat": confirmPassword,
      "google_id": googleId,
      "token": token,
    };

    if (photo != null) {
      String fileName = photo.path.split('/').last;
      data.addAll({
        "photo": await MultipartFile.fromFile(photo.path, filename: fileName)
      });
    }
    if (email.isNotEmpty) {
      data.addAll({"email": email});
    }

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterGoogleTwo")
            .errorMessage();
      }
    }
  }

  Future<User?> postRegisterGoogleFinishing(
      String referralCode,
      String fullName,
      String username,
      String gender,
      String birthdate,
      String address,
      int provinceId,
      int regencyId,
      int subdistrictId,
      int urbanVillageId,
      String postalCode,
      int professionId,
      String phone,
      String email,
      String password,
      String confirmPassword,
      String googleId,
      String token,
      [File? photo]) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/register_google_finish";
    Map<String, dynamic> data = {
      "refferal_code": referralCode,
      "full_name": fullName,
      "username": username,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "province_id": provinceId,
      "regency_id": regencyId,
      "subdistrict_id": subdistrictId,
      "urban_village_id": urbanVillageId,
      "postal_code": postalCode,
      "profession_id": professionId,
      "phone": phone,
      "password": password,
      "password_repeat": confirmPassword,
      "google_id": googleId,
      "token": token,
    };

    if (photo != null) {
      String fileName = photo.path.split('/').last;
      data.addAll({
        "photo": await MultipartFile.fromFile(photo.path, filename: fileName)
      });
    }
    if (email.isNotEmpty) {
      data.addAll({"email": email});
    }

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postRegisterGoogleFinishing")
            .errorMessage();
      }
    }
    return currentUser;
  }

  Future<User?> postUpdateDeviceToken(
      String deviceToken,
      String deviceId,
      String deviceOs,
      String deviceOsVersion,
      String deviceLatitude,
      String deviceLongitude) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    String url = "$baseUrl/my/change_device_token";
    try {
      Response res = await dio.post(
        url,
        data: {
          "token": deviceToken,
          "device_id": deviceId,
          "device_os": deviceOs,
          "device_os_version": deviceOsVersion,
          "device_latitude": deviceLatitude,
          "device_longitude": deviceLongitude
        },
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> linkWithGoogle(
      String email, String googleId, String token) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/google_link";
    Map<String, dynamic> data = {
      "email": email,
      "google_id": googleId,
      "token": token,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      User user = User.fromJson(res.data);

      // if (_currentUser.status == 1) {
      //   currentUser = _currentUser;
      //   _writeUserData();
      // }
      return user;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "linkWithGoogle")
            .errorMessage();
      }
    }
  }

  Future<User?> unlinkGoogle() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/google_unlink";

    try {
      Response res = await dio.post(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "unlinkGoogle")
            .errorMessage();
      }
    }
    return currentUser;
  }

  Future deleteAccount() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/delete_account";

    try {
      Response res = await dio.post(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );

      Logger().d(res.data);
      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "deleteAccount")
            .errorMessage();
      }
    }
  }

  Future cancelDeleteAccount() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    final Dio dio = Dio();
    String url = "$baseUrl/my/delete_account_cancel";

    try {
      Response res = await dio.post(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${currentUser!.data!.token}",
          "isilah-key": apiKey,
          "release": timestamp
        }),
      );
      Logger().d(res.data);
      return res.data;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "cancelDeleteAccount")
          .errorMessage();
    }
  }
}
