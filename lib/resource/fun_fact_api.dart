import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:isilahtitiktitik/model/detail_fun_fact.dart';
import 'package:isilahtitiktitik/model/fun_fact.dart';
import 'package:isilahtitiktitik/model/fun_fact_pantun.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/enc.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:logger/logger.dart';

class FunFactApi {
  final CHttp? http;
  FunFactApi({this.http});

  Future<FunFactModel> fetchFunFact(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio
          .post(getFunFact, data: {"limit": 20, "page": page, "type": 1});
      Logger().d("Response Fun Fact:");
      Logger().d(res.data);
      final FunFactModel funFactModel = FunFactModel.fromJson(res.data);
      return funFactModel;
    } on DioError catch (err) {
      Logger().e("Error Fun Fact: $err");
      if (err.isNoConnectionError) {
        throw 'Not connected';
      }
      if (err.response != null) {
        throw err.response!.data;
      }
      return err.error;
    }
  }

  Future<DetailFunFactModel> fetchDetailFunFact(int id) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.get('/artikel/$id');
      Logger().d(res.data);
      final DetailFunFactModel detailFunFactModel =
          DetailFunFactModel.fromJson(res.data);
      return detailFunFactModel;
    } on DioError catch (err) {
      Logger().e("Error Detail Fun Fact: $err");
      if (err.isNoConnectionError) {
        throw 'Not connected';
      }
      if (err.response != null) {
        throw err.response!.data;
      }
      return err.error;
    }
  }

  Future<FunFactModel> fetchFunFactCarousel() async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(
        getFunFact,
        data: {"limit": 5, "page": 1, "type": 1},
        options: buildCacheOptions(const Duration(minutes: 5),
            maxStale: const Duration(hours: 1)),
      );
      final FunFactModel funFactModel = FunFactModel.fromJson(res.data);
      return funFactModel;
    } on DioError catch (err) {
      Logger().e("Error Fun Fact: $err");
      return err.error;
    }
  }

  Future<FunFactPantunModel> fetchFunFactPantun() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        getFunFactPantun,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      final FunFactPantunModel factPantunModel =
          FunFactPantunModel.fromJson(res.data);
      Logger().d('splash screen : ${res.data}');
      return factPantunModel;
    } on DioError catch (err) {
      Logger().e("Error Fun Fact Pantun: $err");
      return err.error;
    }
  }
}
