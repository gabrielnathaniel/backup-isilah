import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isilahtitiktitik/bloc/single-user-bloc/single_user_bloc.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/fun_fact_widget.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_header_widget.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/mini_games_widget.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/widgets/undian_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isConnectedNetwork = true;
  SingleUserBloc singleUserBloc = SingleUserBloc();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  LocationPermission? permission;
  double latitude = 0;
  double longitude = 0;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Auth authDeviceToken = chttp.auth!;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final deviceId = await _initUniqueIdentifierState();
    final version = await _initPackageInfo();
    final deviceToken = await messaging.getToken();
    if (!serviceEnabled) {
      if (deviceToken != null) {
        if (auth.currentUser!.data!.user!.deviceToken != deviceToken) {
          authDeviceToken
              .postUpdateDeviceToken(
                  deviceToken,
                  deviceId,
                  Platform.isAndroid ? "Android" : "iOS",
                  version.version,
                  "0",
                  "0")
              .then((value) {
            if (value!.status == 1) {
              setState(() {
                prefs.setString("deviceToken", value.data!.user!.deviceToken!);
              });
            } else {
              Logger().e("Gagal Update Devices Token");
            }
          }).catchError((onError) {
            Logger().e("Gagal Update Device Token");
          });
        } else {
          Logger().d("Device Token Sudah Ada");
        }
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (deviceToken != null) {
          if (auth.currentUser!.data!.user!.deviceToken != deviceToken) {
            authDeviceToken
                .postUpdateDeviceToken(
                    deviceToken,
                    deviceId,
                    Platform.isAndroid ? "Android" : "iOS",
                    version.version,
                    "0",
                    "0")
                .then((value) {
              if (value!.status == 1) {
                setState(() {
                  prefs.setString(
                      "deviceToken", value.data!.user!.deviceToken!);
                });
              } else {
                Logger().e("Gagal Update Device Token");
              }
            }).catchError((onError) {
              Logger().e("Gagal Update Device Token");
            });
          } else {
            Logger().d("Device Token Sudah Ada");
          }
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (deviceToken != null) {
        if (auth.currentUser!.data!.user!.deviceToken != deviceToken) {
          authDeviceToken
              .postUpdateDeviceToken(
                  deviceToken,
                  deviceId,
                  Platform.isAndroid ? "Android" : "iOS",
                  version.version,
                  "0",
                  "0")
              .then((value) {
            if (value!.status == 1) {
              setState(() {
                prefs.setString("deviceToken", value.data!.user!.deviceToken!);
              });
            } else {
              Logger().e("Gagal Update Device Token");
            }
          }).catchError((onError) {
            Logger().e("Gagal Update Device Token");
          });
        } else {
          Logger().d("Device Token Sudah Ada");
        }
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> _initUniqueIdentifierState() async {
    final identifier = await UniqueIdentifier.serial;

    return identifier!;
  }

  Future<PackageInfo> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info;
  }

  void getFirebaseToken() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Auth authDeviceToken = chttp.auth!;
    final currentLocation = await _determinePosition();
    final deviceId = await _initUniqueIdentifierState();
    final version = await _initPackageInfo();
    final deviceToken = await messaging.getToken();
    if (deviceToken != null) {
      if (auth.currentUser != null) {
        if (auth.currentUser!.data!.user!.deviceToken != deviceToken) {
          authDeviceToken
              .postUpdateDeviceToken(
                  deviceToken,
                  deviceId,
                  Platform.isAndroid ? "Android" : "iOS",
                  version.version,
                  currentLocation.latitude.toString(),
                  currentLocation.longitude.toString())
              .then((value) {
            if (value!.status == 1) {
              setState(() {
                prefs.setString("deviceToken", value.data!.user!.deviceToken!);
              });
            } else {
              Logger().e("Gagal Update Device Token");
            }
          }).catchError((onError) {
            Logger().e("Gagal Update Device Token");
          });
        } else {
          Logger().d("Device Token Sudah Ada");
        }
      }
    }
  }

  void checkInternetConnection() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnectedNetwork = false;
      });
    } else {
      setState(() {
        isConnectedNetwork = true;
      });
      singleUserBloc.add(GetSingleUser(http: chttp, baseAuth: auth));
    }
  }

  @override
  void initState() {
    getFirebaseToken();
    checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: auth.currentUser == null ? Container() : _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    var height = MediaQuery.of(context).viewPadding.top;
    return !isConnectedNetwork
        ? BlocProvider<SingleUserBloc>(
            create: (context) => singleUserBloc,
            child: NoInternetConnectionWidget(function: () {
              checkInternetConnection();
            }),
          )
        : ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              AnimatedSize(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: height),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/image/img_background_home.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const HomeHeaderWidget())),
              const SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  auth.currentUser!.data!.user!.id == 11
                      ? Container()
                      : const MiniGamesWidget(),
                  const FunFactWidget(title: 'Tau Gak?'),
                  const UndianWidget(title: 'Undian'),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )
            ],
          );
  }
}
