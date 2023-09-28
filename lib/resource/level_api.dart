import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/level.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

class LevelApi {
  final CHttp? http;
  LevelApi({this.http});

  Future<LevelModel> fetchListLevel() async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(getListLevel, data: {"limit": 1000, "page": 0});

      final LevelModel levelModel = LevelModel.fromJson(res.data);
      return levelModel;
    } on DioError catch (err) {
      return err.error;
    }
  }
}
