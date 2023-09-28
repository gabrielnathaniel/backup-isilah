import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

class FriendApi {
  final CHttp? http;
  FriendApi({this.http});

  Future<User> fetchFriend(int userId) async {
    final Dio dio = await http!.getClient();
    try {
      Response res = await dio.post(getFriendData, data: {"id": userId});
      Logger().d("Response Get Friend Data:");
      Logger().d(res.data);
      final User userModel = User.fromJson(res.data);
      return userModel;
    } on DioError catch (err) {
      Logger().e("Error Get Friend Data: $err");
      return err.error;
    }
  }
}
