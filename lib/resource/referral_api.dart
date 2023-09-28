import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/referral_step.dart';
import 'package:isilahtitiktitik/model/referral_user.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class ReferralApi {
  final CHttp? http;
  ReferralApi({this.http});

  Future<ReferralStepModel> fetchReferralStep(int page) async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(referralStep, data: {"limit": 20, "page": page});

      ReferralStepModel referralStepModel =
          ReferralStepModel.fromJson(res.data);
      return referralStepModel;
    } on DioError catch (err) {
      return err.error;
    }
  }

  Future<ReferralUserModel> fetchReferralUser(int page) async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio
          .post(referralUser, data: {"search": "", "limit": 20, "page": page});
      Logger().d(res.data);
      ReferralUserModel referralUserModel =
          ReferralUserModel.fromJson(res.data);
      return referralUserModel;
    } on DioError catch (err) {
      return err.error;
    }
  }

  Future postReferralRedeem(int idPrize) async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(referralRedeem, data: {"prize_id": idPrize});

      return res.data;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postReferralRedeem")
            .errorMessage();
      }
    }
  }
}
