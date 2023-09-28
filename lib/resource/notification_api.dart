import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/notification_main.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:logger/logger.dart';

class NotificationApi {
  final CHttp? http;
  NotificationApi({this.http});

  Future<NotificationModel> fetchNotification() async {
    Dio dio = await http!.getClient();
    try {
      Response res =
          await dio.post(getNotification, data: {"limit": 100, "page": 1});
      Logger().d(res.data);
      NotificationModel notificationModel =
          NotificationModel.fromJson(res.data);
      return notificationModel;
    } on DioError catch (err) {
      if (err.isNoConnectionError) {
        throw 'Not connected';
      }
      if (err.response != null) {
        throw err.response!.data['message']['title'];
      }
      throw err.error;
    }
  }

  Future postReadNotification(int id) async {
    Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getNotificationRead, data: {"id": id});
      return res.data;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }
}
