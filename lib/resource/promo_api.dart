import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/promo.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

class PromoApi {
  final CHttp? http;
  PromoApi({this.http});

  Future<PromoModel> fetchPromo() async {
    final Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(getListPromo, data: {"limit": 100, "page": 1});
      Logger().d("Response Promo : ${res.data}");
      final PromoModel promoModel = PromoModel.fromJson(res.data);
      return promoModel;
    } on DioError catch (err) {
      return err.error;
    }
  }
}
