import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/referral-step-bloc/referral_step_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/referral_step.dart';
import 'package:isilahtitiktitik/resource/referral_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_referral_step_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class ReferralStepPage extends StatefulWidget {
  const ReferralStepPage({Key? key}) : super(key: key);

  @override
  State<ReferralStepPage> createState() => _ReferralStepPageState();
}

class _ReferralStepPageState extends State<ReferralStepPage> {
  bool status = false;

  final ReferralStepBloc _referralStepBloc = ReferralStepBloc();
  int pageNumber = 1;
  int? totalReferral = 0;
  int? totalReferralValid = 0;
  List<DataStep> _listDataStep = [];
  final ScrollController _scStep = ScrollController();
  final tooltipController = JustTheController();
  var length = 10.0;
  var color = Colors.pink;
  var alignment = Alignment.center;

  @override
  void initState() {
    _loadMoreDataRanks(true);

    tooltipController.addListener(() {
      // print('controller: ${tooltipController.value}');
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scStep.dispose();
    _referralStepBloc.close();
  }

  Future<void> _loadMoreDataRanks(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    _referralStepBloc.add(
        GetReferralStep(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _referralStepBloc,
      child: BlocBuilder<ReferralStepBloc, ReferralStepState>(
        builder: (context, state) {
          if (state is ReferralStepInitial) {
            return LoadingReferralStepWidget();
          } else if (state is ReferralStepLoading) {
            return LoadingReferralStepWidget();
          } else if (state is ReferralStepLoaded ||
              state is ReferralStepMoreLoading) {
            if (state is ReferralStepLoaded) {
              _listDataStep = state.list;
              totalReferral = state.totalReferral;
              totalReferralValid = state.totalReferralValid;
            }
            return _buildList();
          } else if (state is ReferralStepError) {
            return _buildEmptyList();
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildList() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    ReferralApi referralApi = ReferralApi(http: chttp);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cara mendapatkan starnya",
                  style: TextStyle(
                      fontSize: bodyLarge,
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Pastikan teman kamu sudah mencapai 101 Exp atau mendapatkan 202 star point dari quiz dan mini games supaya masuk ke daftar user referal kamu.",
                  style:
                      TextStyle(fontSize: 14, color: ColorPalette.neutral_70),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'PlusJakartaSans'),
                        children: [
                          TextSpan(
                            text: '$totalReferralValid',
                            style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(
                            text: ' dari ',
                            style: TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: '$totalReferral',
                            style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(
                            text: ' temanmu telah bermain',
                            style: TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 1500),
                      alignment: alignment,
                      child: JustTheTooltip(
                        onShow: () {
                          // print('onShow');
                        },
                        onDismiss: () {
                          // print('onDismiss');
                        },
                        backgroundColor: ColorPalette.neutral_100,
                        controller: tooltipController,
                        tailLength: length,
                        tailBaseWidth: 20.0,
                        isModal: true,
                        preferredDirection: AxisDirection.down,
                        borderRadius: BorderRadius.circular(8.0),
                        offset: 0,
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 250.0),
                            child: const Text(
                              'Kamu baru akan mendapatkan star jika temanmu sudah mencapai 101 exp atau mendapatkan 202 star point dari quiz',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.info_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ..._listDataStep
              .map((dataStep) => Container(
                    padding: const EdgeInsets.all(8),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: dataStep.status == 1
                          ? Colors.white
                          : ColorPalette.neutral_90.withOpacity(0.1),
                      border: Border.all(color: ColorPalette.neutral_30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_two_coins.png',
                                  width: 100,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'PlusJakartaSans'),
                                          children: <TextSpan>[
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                              text: "${dataStep.priceRefferal}",
                                              style: const TextStyle(
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontSize: bodyLarge,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const TextSpan(
                                              text:
                                                  ' temanmu yang telah bermain',
                                              style: TextStyle(
                                                color: ColorPalette.neutral_90,
                                                fontWeight: FontWeight.w400,
                                                fontSize: bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icon/ic_star_36.png',
                                            width: 22,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            dataStep.prizePoint.toString(),
                                            style: const TextStyle(
                                                color: ColorPalette.neutral_90,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            referralApi
                                                .postReferralRedeem(
                                                    dataStep.id!)
                                                .then((value) {
                                              if (value['status'] == 1) {
                                                Navigator.pop(context);
                                                Flushbar(
                                                  message: value['message']
                                                      ['title'],
                                                  margin:
                                                      const EdgeInsets.all(16),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  messageSize: 12,
                                                  backgroundColor:
                                                      ColorPalette.greenColor,
                                                ).show(context);
                                              } else {
                                                flushbarError(value['message']
                                                        ['title'])
                                                    .show(context);
                                              }
                                            }).catchError((onError) {
                                              flushbarError(onError is String
                                                      ? onError
                                                      : onError['message']
                                                          ['title'])
                                                  .show(context);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            width: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: dataStep.status == 1
                                                    ? ColorPalette.mainColor
                                                    : ColorPalette.colorBorder),
                                            child: const Center(
                                              child: Text(
                                                'Klaim',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        dataStep.status != 1
                            ? Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 100,
                                  child: Image.asset(
                                    'assets/icon/ic_padlock.png',
                                    width: 40,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ))
              .toList(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
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
