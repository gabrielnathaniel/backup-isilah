import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/web/utils/api_helper_web.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/web/utils/auth_web.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Auth()),
  Provider.value(value: AuthWeb()),
  Provider.value(value: Map<String, dynamic>())
];
List<SingleChildWidget> dependentServices = [
  ProxyProvider<Auth, CHttp>(
    update: (context, auth, cHttp) => CHttp(baseURL: baseUrl, auth: auth),
  ),
  ProxyProvider<AuthWeb, CHttpWeb>(
    update: (context, auth, cHttp) => CHttpWeb(baseURL: baseUrl, auth: auth),
  ),
];
List<SingleChildWidget> uiConsumableProviders = [];
