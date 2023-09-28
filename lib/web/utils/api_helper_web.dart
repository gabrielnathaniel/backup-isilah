import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/web/utils/auth_web.dart';

class CHttpWeb {
  const CHttpWeb({this.baseURL, this.auth});

  final String? baseURL;
  final AuthWeb? auth;

  Future<Dio> getClient() async {
    Dio dio = Dio();
    dio.options.baseUrl = baseURL!;

    if (auth == null) {
      return dio;
    }

    final bool isLogin = await auth!.isLoggedIn();
    await auth!.isLoggedIn();

    if (!isLogin) {
      return dio;
    }

    // User? user = await auth!.refreshToken();

    // if (user == null) {
    //   return dio;
    // }

    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] =
            "Bearer ${auth!.currentUser!.data!.token}";
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError err, handler) async {
        if (err.response?.statusCode == 401) {
          auth!.logout();
          // RequestOptions options = err.response!.requestOptions;
          // final opts = Options(method: options.method);
          // options.headers["Authorization"] =
          //     "Bearer ${auth!.currentUser!.data!.token!}";
          // try {
          //   final response = await dio.request(options.path,
          //       options: opts,
          //       data: options.data,
          //       queryParameters: options.queryParameters);
          //   handler.resolve(response);
          // } on DioError catch (error) {
          //   return handler.next(error);
          // }
        } else {
          return handler.next(err);
        }
      },
    ));
    return dio;
  }
}
