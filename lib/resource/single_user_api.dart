import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/model/username_check.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';

class SingleUserApi {
  final CHttp? http;
  SingleUserApi({this.http});

  Future<User> fetchSingleUser() async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getSingleUser);

      User user = User.fromJson(res.data);
      return user;
    } on DioError catch (err) {
      return err.error;
    }
  }

  Future<UsernameCheckModel> fetchUsernameCheck() async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getUsernameCheck);

      UsernameCheckModel usernameCheckModel =
          UsernameCheckModel.fromJson(res.data);
      return usernameCheckModel;
    } on DioError catch (err) {
      return err.error;
    }
  }

  Future postUpdateUsername(String username) async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(postUsernameUpdate, data: {"username": username});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postUpdateUsername")
            .errorMessage();
      }
    }
  }

  Future postUpdateEmailOne(String email) async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(updateEmailOne, data: {"email": email});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postUpdateEmailOne")
            .errorMessage();
      }
    }
  }

  Future postUpdateEmailResend(String email) async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(updateEmailResend, data: {"email": email});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postUpdateEmailResend")
            .errorMessage();
      }
    }
  }

  Future postUpdateEmailTwo(String email, String otp) async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(updateEmailTwo, data: {"email": email, "otp": otp});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postUpdateEmailTwo")
            .errorMessage();
      }
    }
  }

  Future postUpdateEmailFinish(String email, String otp) async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(updateEmailFinish, data: {"email": email, "otp": otp});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postUpdateEmailFinish")
            .errorMessage();
      }
    }
  }
}
