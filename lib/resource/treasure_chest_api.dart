import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/event_detail.dart';
import 'package:isilahtitiktitik/model/leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/model/my_ranking_treasure_chest.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/model/treasure_chest.dart';
import 'package:isilahtitiktitik/model/treasure_chest_answer.dart';
import 'package:isilahtitiktitik/model/treasure_chest_list.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class TreasureChestApi {
  final CHttp? http;
  TreasureChestApi({this.http});

  Future<TreasureChestListModel> fetchTreasureChestList() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(treasureChestList);
      Logger().d(res.data);
      final TreasureChestListModel treasureChestListModel =
          TreasureChestListModel.fromJson(res.data);
      return treasureChestListModel;
    } on DioError catch (err) {
      Logger().e("Error treasure chest list: $err");
      return err.error;
    }
  }

  Future<TreasureChestModel> fetchPlayTreasureChest(int idQuiz) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(startTreasureChest, data: {"event_id": idQuiz});
      Logger().d("Response Play Treasure Chest:");
      Logger().d(res.data);
      final TreasureChestModel treasureChestModel =
          TreasureChestModel.fromJson(res.data);
      return treasureChestModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchPlayTreasureChest")
          .errorMessage();
    }
  }

  Future<EventDetailModel> fetchTreasureChestDetail(int idEvent) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(detailTreasureChest, data: {"event_id": idEvent});

      final EventDetailModel eventDetailModel =
          EventDetailModel.fromJson(res.data);
      return eventDetailModel;
    } on DioError catch (err) {
      Logger().e("Error Get Treasure Chest Detail: $err");
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchTreasureChestDetail")
          .errorMessage();
    }
  }

  Future fetchJoinTreasureChest(int idEvent) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(joinTreasureChest, data: {"event_id": idEvent});
      Logger().d("Response : ${res.data}");
      return res.data;
    } on DioError catch (err) {
      Logger().e("Error Join Treasure Chest: $err");
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(dioError: err, errorFrom: "postAnswer")
            .errorMessage();
      }
    }
  }

  Future<TreasureChestAnswer> postAnswer(int? eventId, int? quizDetailId,
      String? answerCode, int? playTime) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(answerTreasureChest, data: {
        "event_id": eventId,
        "quiz_detail_id": quizDetailId,
        "answer_code": answerCode,
        "play_time": playTime
      });
      Logger().d("Response jawab : ${res.data}");
      final TreasureChestAnswer treasureChestAnswer =
          TreasureChestAnswer.fromJson(res.data);
      return treasureChestAnswer;
    } on DioError catch (err) {
      Logger().e("Error finish quiz: $err");
      Logger().e("Error finish quiz data: ${err.response!.data!}");

      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(dioError: err, errorFrom: "postAnswer")
            .errorMessage();
      }
    }
  }

  Future<ResultQuizModel> fetchResultTreasureChest(int? eventId) async {
    final Dio dio = await http!.getClient();

    try {
      Response res =
          await dio.post(resultTreasureChest, data: {"event_id": eventId});
      Logger().d(res.data);
      final ResultQuizModel resultQuizModel =
          ResultQuizModel.fromJson(res.data);
      return resultQuizModel;
    } on DioError catch (err) {
      throw err.response!.data!;
    }
  }

  Future<LeaderboardTreasureChestModel> fetchLeaderboardTreasureChest(
      int eventId, int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(leaderboardTreasureChest,
          data: {"event_id": eventId, "limit": 20, "page": page});
      Logger().d(res.data);
      final LeaderboardTreasureChestModel leaderboardTreasureChestModel =
          LeaderboardTreasureChestModel.fromJson(res.data);
      return leaderboardTreasureChestModel;
    } on DioError catch (err) {
      Logger().e(err.error);
      return err.error;
    }
  }

  Future<MyRankingTreaseureChestModel> fetchMyRankingTreaseureChestModel(
      int eventId) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio
          .post(leaderboardTreasureChestMine, data: {"event_id": eventId});
      Logger().d(res.data);
      final MyRankingTreaseureChestModel myRankingTreaseureChestModel =
          MyRankingTreaseureChestModel.fromJson(res.data);
      return myRankingTreaseureChestModel;
    } on DioError catch (err) {
      Logger().e(err.error);
      return err.error;
    }
  }
}
