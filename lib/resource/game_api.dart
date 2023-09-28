import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class GameApi {
  final CHttp? http;
  GameApi({this.http});

  Future<ListGameModel> fetchListGame(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(getListGame, data: {"limit": 10, "page": page});
      final ListGameModel listGameModel = ListGameModel.fromJson(res.data);
      return listGameModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchListGame")
          .errorMessage();
    }
  }

  Future postGameResult(String token, int idGame, int level, int result,
      String start, String end) async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(finishGame, data: {
        "token": token,
        "game_id": idGame,
        "level": level,
        "results": result,
        "start": start,
        "end": end
      });
      Logger().d(res.data.toString());

      return res.data;
    } on DioError catch (err) {
      Logger().e(err.message);
      throw err.response!.data;
    }
  }
}
