// import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuthWeb {
  Future<User?> login(String email, String password);
  Future<User?> loginWithGoogle(String email, String token);
  Future<User?> loadUserAuth();
  Future<User?> loadSingleUser();
  Future<bool?> isLoggedIn();
  Future<bool?> isOnboardVisited();
  void logout();
  User? currentUser;
}

class AuthWeb implements BaseAuthWeb {
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
              )));
      currentUser = userAuth;
    }
    return currentUser;
  }

  @override
  Future<User?> login(String email, String password) async {
    final Dio dio = Dio();
    String url = "$baseUrl/login";
    try {
      Response res =
          await dio.post(url, data: {"email": email, "password": password});

      User currentUser = User.fromJson(res.data);
      currentUser = currentUser;
      _writeUserData();
    } on DioError catch (err) {
      _deleteUserData();
      currentUser = null;
      throw err.response!.data;
    }
    return currentUser;
  }

  @override
  Future<User?> loginWithGoogle(String email, String token) async {
    final Dio dio = Dio();
    String url = "$baseUrl/login_google";
    try {
      Response res =
          await dio.post(url, data: {"email": email, "token": token});

      User currentUser = User.fromJson(res.data);
      currentUser = currentUser;
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
    final Dio dio = Dio();
    String url = "$baseUrl/my/profile";
    try {
      Response res = await dio.post(url,
          options: Options(headers: {
            "Authorization": "Bearer ${currentUser!.data!.token}"
          }));
      // log("Response Single User: $_res");
      final User userModel = User.fromJson(res.data);
      currentUser = userModel;
      _writeUserData();
    } on DioError catch (err) {
      if (err.response!.statusCode == 401) {
        _deleteUserData();
        currentUser = null;
      }
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
      prefs.setString("email", currentUser!.data!.user!.email!);
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

    currentUser = null;
  }

  @override
  void logout() {
    _deleteUserData();
  }

  Future fetchLogout() async {
    Dio dio = Dio();
    String url = "$baseUrl/logout";
    try {
      Response res = await dio.get(
        url,
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future postRegisterOne(
      String referralCode,
      String fullName,
      String gender,
      String birthdate,
      String address,
      String postalCode,
      int professionId,
      String facebook,
      String instagram,
      String twitter) async {
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_one";
    FormData formData = FormData.fromMap({
      "refferal_code": referralCode,
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "postal_code": postalCode,
      "profession_id": professionId,
      "socmed_fb": facebook,
      "socmed_ig": instagram,
      "socmed_tw": twitter,
    });

    try {
      Response res = await dio.post(url, data: formData);

      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future postRegisterResendOTP(String email) async {
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_resend";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
      );

      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future postRegisterVerifyOTP(String email, String otp) async {
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_three";
    Map<String, dynamic> data = {
      "email": email,
      "otp": otp,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
      );

      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User> changePassword(
      String oldPassowrd, String newPassword, String confirmPassowrd) async {
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
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future forgotPassword(String email) async {
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_step_one";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future forgotPasswordResendOTP(String email) async {
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_resend";
    Map<String, dynamic> data = {
      "email": email,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future forgotPasswordVerifyOTP(String email, String otp) async {
    final Dio dio = Dio();
    String url = "$baseUrl/forgot_password_step_two";
    Map<String, dynamic> data = {
      "email": email,
      "otp": otp,
    };

    FormData formData = FormData.fromMap(data);

    try {
      Response res = await dio.post(
        url,
        data: formData,
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> forgotPasswordFinishing(String email, String otp,
      String newPassword, String confirmPassword) async {
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
      Response res = await dio.post(
        url,
        data: formData,
      );
      User currentUser = User.fromJson(res.data);
      currentUser = currentUser;
      _writeUserData();
    } on DioError catch (err) {
      throw err.response!.data;
    }
    return currentUser;
  }

  Future<User> fetchOverview() async {
    final Dio dio = Dio();
    String url = "$baseUrl/my/profile";
    try {
      Response res = await dio.post(
        url,
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> postReferralUpdate(String referralCode) async {
    Dio dio = Dio();
    String url = "$baseUrl/my/profile_update_refferal";
    try {
      Response res = await dio.post(
        url,
        data: {"refferal_code": referralCode},
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );

      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future postRegisterGoogleOne(
      String referralCode,
      String fullName,
      String gender,
      String birthdate,
      String address,
      String postalCode,
      int professionId) async {
    final Dio dio = Dio();
    String url = "$baseUrl/register_step_one";
    FormData formData = FormData.fromMap({
      "refferal_code": referralCode,
      "full_name": fullName,
      "gender": gender,
      "birthdate": birthdate,
      "address": address,
      "postal_code": postalCode,
      "profession_id": professionId
    });

    try {
      Response res = await dio.post(url, data: formData);

      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> postUpdateDeviceToken(String deviceToken) async {
    Dio dio = Dio();
    String url = "$baseUrl/my/change_device_token";
    try {
      Response res = await dio.post(
        url,
        data: {"token": deviceToken},
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );

      final User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> linkWithGoogle(
      String email, String googleId, String token) async {
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
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      User user = User.fromJson(res.data);

      // if (_currentUser.status == 1) {
      //   currentUser = _currentUser;
      //   _writeUserData();
      // }
      return user;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<User?> unlinkGoogle() async {
    final Dio dio = Dio();
    String url = "$baseUrl/my/google_unlink";

    try {
      Response res = await dio.post(
        url,
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      User user = User.fromJson(res.data);
      currentUser = user;
      _writeUserData();
    } on DioError catch (err) {
      throw err.response!.data;
    }
    return currentUser;
  }

  Future deleteAccount() async {
    final Dio dio = Dio();
    String url = "$baseUrl/my/delete_account";

    try {
      Response res = await dio.post(
        url,
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future cancelDeleteAccount() async {
    final Dio dio = Dio();
    String url = "$baseUrl/my/delete_account_cancel";

    try {
      Response res = await dio.post(
        url,
        options: Options(
            headers: {"Authorization": "Bearer ${currentUser!.data!.token}"}),
      );
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }
}
