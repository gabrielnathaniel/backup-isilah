import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/referral-user-bloc/referral_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/referral_user.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllReferralUserPage extends StatefulWidget {
  const AllReferralUserPage({super.key});

  @override
  State<AllReferralUserPage> createState() => _AllReferralUserPageState();
}

class _AllReferralUserPageState extends State<AllReferralUserPage> {
  bool status = false;

  final ReferralUserBloc _referralUserBloc = ReferralUserBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? totalReferral = 0;
  int? _currentLenght;
  List<DataReferralUser> _listReferralUser = [];
  final ScrollController _scReferralUser = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreDataReferral(true);
    _scReferralUser.addListener(() {
      if (_scReferralUser.position.pixels ==
          _scReferralUser.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreDataReferral(false);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scReferralUser.dispose();
    _referralUserBloc.close();
    super.dispose();
  }

  Future<void> _loadMoreDataReferral(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    _referralUserBloc.add(
        GetReferralUser(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/image/img_background_appbar.png'),
          fit: BoxFit.fitWidth,
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Teman Referral',
          style: TextStyle(
              fontSize: titleSmall,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: BlocProvider(
        create: (context) => _referralUserBloc,
        child: BlocBuilder<ReferralUserBloc, ReferralUserState>(
          builder: (context, state) {
            if (state is ReferralUserInitial) {
              return const LoadingWidget();
            } else if (state is ReferralUserLoading) {
              return const LoadingWidget();
            } else if (state is ReferralUserLoaded ||
                state is ReferralUserMoreLoading) {
              if (state is ReferralUserLoaded) {
                _listReferralUser = state.list;
                _currentLenght = state.count;
                _limit = state.limit;
                totalReferral = state.totalReferral;
              }
              return _buildList();
            } else if (state is ReferralUserError) {
              return _buildEmptyList();
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_listReferralUser.isEmpty) {
      return _buildEmptyList();
    }
    return SingleChildScrollView(
        controller: _scReferralUser,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Kamu mempunyai ',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: bodyMedium,
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        text: "$totalReferral user",
                        style: const TextStyle(
                            color: ColorPalette.neutral_90,
                            fontSize: bodyMedium,
                            fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(
                        text: ' yang menggunakan kode undangan kamu',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ..._listReferralUser
              .map((dataReferralUser) => Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorPalette.neutral_30,
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl + dataReferralUser.photo!,
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
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
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
                              child: Text(
                                dataReferralUser.fullName!,
                                style: const TextStyle(
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            dataReferralUser.statusValid == 1
                                ? Image.asset(
                                    'assets/icon/ic_verify.png',
                                    width: 24,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ))
              .toList(),
          const SizedBox(
            height: 16,
          ),
        ]));
  }

  Widget _buildEmptyList() {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Image.asset(
          'assets/image/img_empty_referral.png',
          width: 120,
        ),
        const SizedBox(
          height: 32,
        ),
        const Text(
          'kamu belum mempunyai referal\nayo undang teman kamu~',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.neutral_90,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ]),
    );
  }
}
