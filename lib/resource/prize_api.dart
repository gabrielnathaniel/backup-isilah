import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:isilahtitiktitik/model/claim_finish.dart';
import 'package:isilahtitiktitik/model/claim_histories.dart';
import 'package:isilahtitiktitik/model/claim_prize.dart';
import 'package:isilahtitiktitik/model/pemenang_undian.dart';
import 'package:isilahtitiktitik/model/prize.dart';
import 'package:isilahtitiktitik/model/undian.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class PrizeApi {
  final CHttp? http;
  PrizeApi({this.http});

  Future<PrizeModel> fetchPrize() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getPrize);
      Logger().d("Response Fetch Prize:");
      Logger().d(res.data);
      final PrizeModel prizeModel = PrizeModel.fromJson(res.data);
      return prizeModel;
    } on DioError catch (err) {
      Logger().e("Error Fetch Prize: $err");
      return err.error;
    }
  }

  Future<ClaimPrizeModel> postClaimPrizeStepOne() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(claimPrizeStepOne);
      Logger().d("Response Claim Step One:");
      Logger().d(res.data);
      final ClaimPrizeModel claimModel = ClaimPrizeModel.fromJson(res.data);
      return claimModel;
    } on DioError catch (err) {
      Logger().e("Error Claim Step One: ${err.error}");
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postClaimPrizeStepOne")
            .errorMessage();
      }
    }
  }

  Future<ClaimPrizeModel> postClaimPrizeStepTwo(
    int id,
    String gender,
    String receiverName,
    String phone,
    String address,
    int urbanVillageId,
    int subdistrictId,
    int regencyId,
    int provinceId,
  ) async {
    final Dio dio = await http!.getClient();
    FormData formData = FormData.fromMap({
      "id": id,
      "gender": gender,
      "receiver_name": receiverName,
      "phone": phone,
      "address": address,
      "postal_code": "",
      "urban_village_id": urbanVillageId,
      "subdistrict_id": subdistrictId,
      "regency_id": regencyId,
      "province_id": provinceId,
    });
    try {
      Response res = await dio.post(claimPrizeStepTwo, data: formData);
      Logger().d("Response Claim Step Two:");
      Logger().d(res.data);
      final ClaimPrizeModel claimModel = ClaimPrizeModel.fromJson(res.data);
      return claimModel;
    } on DioError catch (err) {
      Logger().e("Error Claim Step Two: ${err.error}");
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postClaimPrizeStepTwo")
            .errorMessage();
      }
    }
  }

  Future<ClaimFinishModel> postClaimPrizeFinish(
    int prizeId,
    int shipmentId,
    int qty,
  ) async {
    final Dio dio = await http!.getClient();
    FormData formData = FormData.fromMap({
      "prize_id": prizeId,
      "shipment_id": shipmentId,
      "qty": qty,
    });

    try {
      Response res = await dio.post(claimPrizeFinish, data: formData);
      Logger().d("Response Claim Finish:");
      Logger().d(res.data);
      final ClaimFinishModel claimModel = ClaimFinishModel.fromJson(res.data);
      return claimModel;
    } on DioError catch (err) {
      Logger().e("Error Claim Finish: ${err.error}");
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "postClaimPrizeFinish")
            .errorMessage();
      }
    }
  }

  Future<ClaimHistoriesModel> fetchHistoriesClaim(int page, String search,
      String sortBy, String sort, String? status) async {
    final Dio dio = await http!.getClient();
    FormData formData = FormData.fromMap({
      "search": search,
      "limit": 10,
      "status": status == null ? null : int.parse(status),
      "page": page,
      "sortBy": sortBy,
      "sort": sort,
    });
    try {
      Response res = await dio.post(claimHistories, data: formData);
      Logger().d("Response List Game:");
      Logger().d(res.data);
      final ClaimHistoriesModel claimHistoriesModel =
          ClaimHistoriesModel.fromJson(res.data);
      return claimHistoriesModel;
    } on DioError catch (err) {
      Logger().e("Error List Game: $err");
      return err.error;
    }
  }

  /// Get API undian
  Future<UndianModel> fetchUndian() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(
        getWinner,
        options: buildCacheOptions(const Duration(minutes: 10),
            maxStale: const Duration(hours: 1)),
      );
      final UndianModel undianModel = UndianModel.fromJson(res.data);
      return undianModel;
    } on DioError catch (err) {
      Logger().e("Error Fetch Prize: $err");
      return err.error;
    }
  }

  /// Get API Pemenang Undian
  Future<PemenangUndianModel> fetchPemenangUndian(String date) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getWinnerView, data: {"date": date});
      Logger().d("Response Fetch Pemenang Undian : $res");
      final PemenangUndianModel pemenangUndianModel =
          PemenangUndianModel.fromJson(res.data);
      return pemenangUndianModel;
    } on DioError catch (err) {
      Logger().e("Error Fetch Pemenang Undian: $err");
      return err.error;
    }
  }

  /// Get API prize next level
  Future<PrizeModel> fetchPrizeNextLevel() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getPrizeNextLevel);
      Logger().d("Response Fetch Next Level Prize:");
      Logger().d(res.data);
      final PrizeModel prizeModel = PrizeModel.fromJson(res.data);
      return prizeModel;
    } on DioError catch (err) {
      Logger().e("Error Fetch Prize: $err");
      return err.error;
    }
  }
}
