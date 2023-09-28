import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/history.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class HistoryApi {
  final CHttp? http;
  HistoryApi({this.http});

  Future<HistoryModel> fetchHistory(
      String startDate, String endDate, int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getHistory, data: {
        "date_from": startDate,
        "date_to": endDate,
        "limit": 14,
        "page": page
      });
      Logger().d("Response History: ${res.data}");

      final HistoryModel historyModel = HistoryModel.fromJson(res.data);
      return historyModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(dioError: err, errorFrom: "fetchHistory")
          .errorMessage();
    }
  }
}
