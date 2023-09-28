import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/model/single_rank.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class RanksApi {
  final CHttp? http;
  RanksApi({this.http});

  Future<SingleUserRanksModel> fetchUserRank(String type) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post("$userLeaderboard/$type");
      Logger().d('single user : ${res.data}');
      final SingleUserRanksModel singleUserRanksModel =
          SingleUserRanksModel.fromJson(res.data);
      return singleUserRanksModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchUserRank")
          .errorMessage();
    }
  }

  /// Fungsi ini [obsolete]
  // Future<RanksModel> fetchRankByType(int page, String type) async {
  //   final Dio dio = await http!.getClient();
  //   try {
  //     Response res = await dio
  //         .post("$leaderboardAllTime$type", data: {"limit": 20, "page": page});
  //     Logger().d(res.data);
  //     final RanksModel ranksModel = RanksModel.fromJson(res.data);
  //     return ranksModel;
  //   } on DioError catch (err) {
  //     Logger().e("Error rank today: $err");
  //     if (err.response != null) {
  //       if (err.response!.statusCode == 401) {
  //         throw err.response!.statusCode!;
  //       } else {
  //         throw err.response!.data;
  //       }
  //     }
  //     throw err.error;
  //   }
  // }

  Future<RanksModel> fetchRankAllTime(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(leaderboardAllTime, data: {"limit": 20, "page": page});
      Logger().d(res.data);
      final RanksModel ranksModel = RanksModel.fromJson(res.data);
      return ranksModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchRankAllTime")
          .errorMessage();
    }
  }

  Future<RanksModel> fetchRankToday(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(leaderboardToday, data: {"limit": 20, "page": page});
      Logger().d(res.data);
      final RanksModel ranksModel = RanksModel.fromJson(res.data);
      return ranksModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchRankToday")
          .errorMessage();
    }
  }

  Future<RanksModel> fetchRankWeekly(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(leaderboardWeekly, data: {"limit": 20, "page": page});
      Logger().d(res.data);
      final RanksModel ranksModel = RanksModel.fromJson(res.data);
      return ranksModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchRankWeekly")
          .errorMessage();
    }
  }

  Future<RanksModel> fetchRankMonthly(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(leaderboardMonthly, data: {"limit": 20, "page": page});
      Logger().d(res.data);
      final RanksModel ranksModel = RanksModel.fromJson(res.data);
      return ranksModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchRankMonthly")
          .errorMessage();
    }
  }
}
