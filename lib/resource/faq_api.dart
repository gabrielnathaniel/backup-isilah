import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/faq.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

class FaqApi {
  final CHttp? http;
  FaqApi({this.http});

  Future<FaqModel> fetchFaq(int page) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getFaq, data: {
        // "date_from": "2023-04-01",
        // "date_to": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "limit": 100,
        "page": 1,
      });
      Logger().d("Response FAQ: ${res.data}");

      final FaqModel faqModel = FaqModel.fromJson(res.data);
      return faqModel;
    } on DioError catch (err) {
      Logger().e("Error FAQ: $err");
      return err.error;
    }
  }
}
