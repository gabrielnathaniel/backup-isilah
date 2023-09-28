import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/single-user-bloc/single_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-voucher/page_voucher.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isConnect = false;
  bool isConnectedNetwork = true;
  SingleUserBloc singleUserBloc = SingleUserBloc();

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
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    singleUserBloc.add(GetSingleUser(http: chttp, baseAuth: auth));
    _checkLinkConnect();
    checkInternetConnection();
    super.initState();
  }

  @override
  void dispose() {
    singleUserBloc.close();
    super.dispose();
  }

  void _checkLinkConnect() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    if (auth.currentUser != null) {
      if (auth.currentUser!.data!.user!.googleLink == 0) {
        setState(() {
          isConnect = false;
        });
      } else {
        setState(() {
          isConnect = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    auth.isLoggedIn().then((value) {
      if (!value!) {
        auth.logout();
        if (Platform.isIOS) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginByEmailPage(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnBoardingPage(),
              ),
              (route) => false);
        }
      }
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomeWidget(
            showBanner: false,
          );
        }));
        return true;
      },
      child: BlocProvider<SingleUserBloc>(
        create: (context) => singleUserBloc,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: !isConnectedNetwork
              ? NoInternetConnectionWidget(function: () {
                  checkInternetConnection();
                })
              : auth.currentUser == null
                  ? Container()
                  : _buildSingleUser(),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 180,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleUser() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4,
            padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/img_background_profile.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: bodyLarge,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                BlocListener<SingleUserBloc, SingleUserState>(
                  listener: (context, state) {
                    if (state is SingleUserNotAuth) {
                      BaseAuth auth = Provider.of<Auth>(context, listen: false);
                      auth.isLoggedIn().then((value) {
                        if (!value!) {
                          auth.logout();
                          if (Platform.isIOS) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginByEmailPage(),
                                ),
                                (route) => false);
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const OnBoardingPage(),
                                ),
                                (route) => false);
                          }
                        }
                      });
                    }
                    if (state is SingleUserUpdateApp) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => UpdateAppWidget(
                              link: Platform.isAndroid ? androidUrl : iOSUrl,
                            ),
                          ),
                          (route) => false);
                    }
                  },
                  child: BlocBuilder<SingleUserBloc, SingleUserState>(
                    builder: (context, state) {
                      if (state is SingleUserInitial) {
                        return _loadingWidget();
                      } else if (state is SingleUserLoading) {
                        return _loadingWidget();
                      } else if (state is SingleUserLoaded) {
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: state.user.data!.user!.photo == null
                                    ? ""
                                    : imageUrl + state.user.data!.user!.photo!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                    width: 50,
                                    height: 50,
                                  ),
                                )),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      "assets/image/default_profile.png",
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.user.data!.user!.username ??
                                              "-",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodyMedium,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ID ${state.user.data!.user!.id ?? "-"}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: bodyMedium,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is SingleUserError) {
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/statistics');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_statistics.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Statistik',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_history.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Riwayat Star',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/referral');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_referral.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Referral',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const VoucherPage();
              }));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_voucher.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Voucher',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/options');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_options.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Pengaturan',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_help.png',
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: ColorPalette.neutral_90,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
