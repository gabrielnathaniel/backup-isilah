import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/answer.dart';
import 'package:isilahtitiktitik/model/play_quiz.dart';
import 'package:isilahtitiktitik/model/quetions_view.dart';
import 'package:isilahtitiktitik/model/reaction.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/model/daily_event.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizApi {
  final CHttp? http;
  QuizApi({this.http});

  Future<DailyEventModel> fetchDailyEvent(String timezone, int gmt) async {
    final Dio dio = await http!.getClient();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response res = await dio.post(getDailyEvent, data: {
        "user_id": prefs.getInt("id"),
        "timezone": timezone,
        "gmt": gmt
      });
      Logger().d(res.data);
      final DailyEventModel dailyEventModel =
          DailyEventModel.fromJson(res.data);
      return dailyEventModel;
    } on DioError catch (err) {
      Logger().e("Error Daily Event: $err");
      return err.error;
    }
  }

  Future<PlayQuizModel> fetchPlayQuiz(int idQuiz) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(playQuiz, data: {"event_id": idQuiz});
      Logger().d("Response Play Quiz:");
      Logger().d(res.data);
      final PlayQuizModel playQuizModel = PlayQuizModel.fromJson(res.data);
      return playQuizModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchPlayQuiz")
          .errorMessage();
    }
  }

  Future<ResultQuizModel> postAnswer(
      int? quizId, List<AnswerModel>? answerList) async {
    final Dio dio = await http!.getClient();

    Map<String, dynamic> dataToJson() {
      return {
        "quiz_id": quizId,
        "answers": List<dynamic>.from(answerList!.map((x) => x.toJson())),
      };
    }

    Logger().d("send body : ${dataToJson().toString()}");
    try {
      Response res = await dio.post(finishQuiz, data: dataToJson());

      Logger().d("Response finish quiz:");
      Logger().d(res.data);
      final ResultQuizModel resultQuizModel =
          ResultQuizModel.fromJson(res.data);
      return resultQuizModel;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(dioError: err, errorFrom: "postAnswer")
            .errorMessage();
      }
    }
  }

  Future<ReactionModel> fetchReaction(String type) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(reaction, data: {"group": "quiz", "type": type});
      final ReactionModel reactionModel = ReactionModel.fromJson(res.data);
      return reactionModel;
    } on DioError catch (err) {
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "fetchReaction")
            .errorMessage();
      }
    }
  }

  Future<QuetionsViewModel> fetchQuestionsView(int questionId) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(questionIdUrl, data: {"question_id": questionId});
      final QuetionsViewModel quetionsViewModel =
          QuetionsViewModel.fromJson(res.data);
      return quetionsViewModel;
    } on DioError catch (err) {
      Logger().e("Error Questions: $err");
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchQuestionsView")
          .errorMessage();
    }
  }
}
