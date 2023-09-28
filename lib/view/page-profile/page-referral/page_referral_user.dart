import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/referral-user-bloc/referral_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/referral_user.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-profile/page-referral/page_all_referral_user.dart';
import 'package:isilahtitiktitik/view/widgets/loading_referral_user_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReferralUserPage extends StatefulWidget {
  const ReferralUserPage({Key? key}) : super(key: key);

  @override
  State<ReferralUserPage> createState() => _ReferralUserPageState();
}

class _ReferralUserPageState extends State<ReferralUserPage> {
  bool status = false;

  final ReferralUserBloc _referralUserBloc = ReferralUserBloc();
  int pageNumber = 1;
  int? totalReferral = 0;
  List<DataReferralUser> _listReferralUser = [];

  @override
  void initState() {
    _loadMoreDataReferral(true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _referralUserBloc.close();
  }

  Future<void> _loadMoreDataReferral(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    _referralUserBloc.add(
        GetReferralUser(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _referralUserBloc,
      child: BlocBuilder<ReferralUserBloc, ReferralUserState>(
        builder: (context, state) {
          if (state is ReferralUserInitial) {
            return LoadingReferralUserWidget();
          } else if (state is ReferralUserLoading) {
            return LoadingReferralUserWidget();
          } else if (state is ReferralUserLoaded ||
              state is ReferralUserMoreLoading) {
            if (state is ReferralUserLoaded) {
              _listReferralUser = state.list;
              totalReferral = state.totalReferral;
            }
            return _buildList();
          } else if (state is ReferralUserError) {
            return _buildEmptyList();
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildList() {
    if (_listReferralUser.isEmpty) {
      return _buildEmptyList();
    }
    return Column(children: [
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
          .take(4)
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
                            imageBuilder: (context, imageProvider) => Container(
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
                            dataReferralUser.username ?? '',
                            style: TextStyle(
                              fontSize: bodyMedium,
                              color: dataReferralUser.statusValid == 1
                                  ? ColorPalette.neutral_90
                                  : ColorPalette.neutral_60,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
        height: 8,
      ),
      _listReferralUser.length > 4
          ? Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllReferralUserPage()));
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                        color: ColorPalette.mainColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12),
                  ),
                ),
              ),
            )
          : Container(),
      const SizedBox(
        height: 16,
      ),
    ]);
  }

  Widget _buildEmptyList() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }
}
