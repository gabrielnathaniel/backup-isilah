import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/enc.dart';
import 'auth.dart';

class CHttp {
  const CHttp({this.baseURL, this.auth});

  final String? baseURL;
  final Auth? auth;

  Future<Dio> getClient() async {
    Dio dio = Dio();
    dio.options.baseUrl = baseURL!;

    if (auth == null) {
      return dio;
    }

    final bool isLogin = await auth!.isLoggedIn();

    if (!isLogin) {
      return dio;
    }

    // User? user = await auth!.refreshToken();

    // if (user == null) {
    //   return dio;
    // }

    /// get timestamp for API-Key
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);

    dio.interceptors.clear();
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] =
            "Bearer ${auth!.currentUser!.data!.token}";
        options.headers['isilah-key'] = apiKey;
        options.headers['release'] = timestamp;
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
        }
        return handler.next(err);
      },
    ));
    return dio;
  }
}
