import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:isilahtitiktitik/bloc/prize-bloc/prize_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/prize.dart';
import 'package:isilahtitiktitik/resource/prize_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_success_claim.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_ubah_data_pengiriman.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PrizeWidget extends StatefulWidget {
  const PrizeWidget({Key? key}) : super(key: key);

  @override
  State<PrizeWidget> createState() => _PrizeWidgetState();
}

class _PrizeWidgetState extends State<PrizeWidget> {
  PrizeBloc prizeBloc = PrizeBloc();

  List<int> listShimmer = [1, 2, 3, 4];

  bool _isClaim = true;
  bool _isLoadingClaim = true;

  int _initialValue = 0;
  int _stepValue = 0;
  int _minValue = 0;
  int _maxValue = 0;
  int _totalValue = 1;

  String? addressDetail;
  String? postalCode;
  String? addressDetailShow;
  String? receiverNameShow;
  String? phoneShow;

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    prizeBloc.add(GetPrize(http: chttp, context: context));

    super.initState();
  }

  @override
  void dispose() {
    prizeBloc.close();
    super.dispose();
  }

  void _postClaimStepOne(int prizeId, int qty, StateSetter setState) async {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    PrizeApi prizeApi = PrizeApi(http: chttp);

    setState(() {
      _isLoadingClaim = false;
    });

    await prizeApi.postClaimPrizeStepOne().then((valueStepOne) async {
      if (valueStepOne.status == 1) {
        await prizeApi
            .postClaimPrizeStepTwo(
          valueStepOne.data!.shipment!.id!,
          valueStepOne.data!.user!.gender ?? 'm',
          basket['receiverName'] ?? valueStepOne.data!.user!.fullName!,
          basket['phone'] ?? valueStepOne.data!.user!.phone!,
          addressDetail ?? valueStepOne.data!.user!.address!,
          basket['idUrbanVillage'] ?? valueStepOne.data!.user!.urbanVillageId,
          basket['idSubdistrict'] ?? valueStepOne.data!.user!.subdistrictId,
          basket['idCity'] ?? valueStepOne.data!.user!.regencyId,
          basket['idProvince'] ?? valueStepOne.data!.user!.provinceId,
        )
            .then((valueStepTwo) async {
          if (valueStepTwo.status == 1) {
            await prizeApi
                .postClaimPrizeFinish(
                    prizeId, valueStepTwo.data!.shipment!.id!, qty)
                .then((valuesFinish) {
              if (valuesFinish.status == 1) {
                setState(() {
                  basket['receiverName'] = null;
                  basket['phone'] = null;
                  basket['address'] = null;
                  basket['postalCode'] = null;
                  basket['idProvince'] = null;
                  basket['idCity'] = null;
                  basket['idSubdistrict'] = null;
                  basket['idUrbanVillage'] = null;
                  basket['nameProfesi'] = null;
                  basket['nameProvince'] = null;
                  basket['nameCity'] = null;
                  basket['nameSubdistrict'] = null;
                  basket['nameUrbanVillage'] = null;
                  _isLoadingClaim = true;
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SuccessClaimPage(
                          listClaim: valuesFinish.data,
                        )));
              } else {
                setState(() {
                  _isLoadingClaim = true;
                });
                flushbarError(valuesFinish.message!.title ??
                        "Terjadi kesalahan, silahkan coba kembali")
                    .show(context);
              }
            }).catchError((onError) {
              setState(() {
                _isLoadingClaim = true;
              });
              flushbarError(
                      onError is String ? onError : onError['message']['title'])
                  .show(context);
            });
          } else {
            setState(() {
              _isLoadingClaim = true;
            });
            flushbarError(valueStepTwo.message!.title ??
                    "Terjadi kesalahan, silahkan coba kembali")
                .show(context);
          }
        }).catchError((onError) {
          Logger().d("error $onError");
          setState(() {
            _isLoadingClaim = true;
          });
          flushbarError(
                  onError is String ? onError : onError['message']['title'])
              .show(context);
        });
      } else {
        setState(() {
          _isLoadingClaim = true;
        });
        flushbarError(valueStepOne.message!.title ??
                "Terjadi kesalahan, silahkan coba kembali")
            .show(context);
      }
    }).catchError((onError) {
      Logger().d("error $onError");
      setState(() {
        _isLoadingClaim = true;
      });
      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => prizeBloc,
      child: BlocBuilder<PrizeBloc, PrizeState>(
        builder: (context, state) {
          if (state is PrizeInitial) {
            return _loadingPrize();
          } else if (state is GetPrizeLoading) {
            return _loadingPrize();
          } else if (state is GetPrizeLoaded) {
            return _buildHeader(context, state.prizeModel);
          } else if (state is GetPrizeError) {
            return const Center(
              child: EmptyStateWidget(
                sizeWidth: 200,
                title: 'Oops!',
                subTitle: 'Terjadi kesalahan, silahkan coba kembali',
              ),
            );
            // return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PrizeModel prizeModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Hadiah Minggu Ini",
                style: TextStyle(
                  fontSize: bodyMedium,
                  color: ColorPalette.neutral_90,
                  fontWeight: FontWeight.w600,
                ),
              ),
              prizeModel.data!.data!.isEmpty
                  ? Container()
                  : RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'PlusJakartaSans'),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Diundi Tanggal ',
                            style: TextStyle(
                              fontSize: bodySmall,
                              color: ColorPalette.mainColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: prizeModel.data!.data![0].drawnOn == null
                                ? ''
                                : IsilahHelper.formatDays(
                                    prizeModel.data!.data![0].drawnOn!),
                            style: const TextStyle(
                              fontSize: bodySmall,
                              color: ColorPalette.mainColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        prizeModel.data!.data!.isEmpty
            ? const EmptyStateWidget(
                sizeWidth: 200,
                title: 'Hadiah Minggu Ini Belum Muncul',
                subTitle: 'Tungguin ya hadiah spesial dari mas slamet',
              )
            : _buildWeeklyPrize(prizeModel),
      ],
    );
  }

  Widget _buildWeeklyPrize(PrizeModel prizeModel) {
    return Column(
      children: [
        ...prizeModel.data!.data!
            .map(
              (prizes) => GestureDetector(
                onTap: () {
                  if (prizes.levelCanClaim == 1) {
                    setAddressDetail(setState);
                    _modalDetailPrize(context, prizes);
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 24),
                      height: 118,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.neutral_30),
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              prizes.photo == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        "assets/image/default_image.png",
                                        width: 118,
                                        height: 118,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        width: 118,
                                        height: 118,
                                        imageUrl: imageUrl + prizes.photo!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              width: 118,
                                              height: 118,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/image/default_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${prizes.prize}",
                                        style: const TextStyle(
                                            color: ColorPalette.neutral_90,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 16),
                                          decoration: BoxDecoration(
                                              color: ColorPalette.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                'assets/icon/ic_star_single.png',
                                                width: 12,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                IsilahHelper
                                                        .formatCurrencyWithoutSymbol(
                                                            prizes.pricePoint!
                                                                .toDouble())
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          prizes.levelCanClaim == 1
                              ? Container()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: ColorPalette.neutral_30
                                          .withOpacity(0.5),
                                      border: Border.all(
                                          color: ColorPalette.neutral_30),
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                        ],
                      ),
                    ),
                    prizes.priceRefferal != 0
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 90,
                              height: 40,
                              padding: const EdgeInsets.only(left: 14),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                      'assets/icon/ic_bagde_prize_pool.png',
                                      width: double.infinity,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 9),
                                      child: Text(
                                        'Min. ${prizes.priceRefferal} Referal',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _loadingPrize() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  width: 118,
                  height: 14,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  width: 150,
                  height: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          ...listShimmer
              .map(
                (shimm) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 118,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.neutral_30),
                      borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              width: 118,
                              height: 118,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: 130,
                                      height: 14,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width: 70,
                                        height: 24,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _modalDetailPrize(
      BuildContext context, PrizeDataDetail prizeDataDetail) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    setState(() {
      _initialValue = prizeDataDetail.pricePoint!;
      _stepValue = prizeDataDetail.pricePoint!;
      _minValue = prizeDataDetail.pricePoint!;
      _maxValue = auth.currentUser!.data!.user!.point!;
      _totalValue = 1;
    });

    if (auth.currentUser!.data!.user!.point! < prizeDataDetail.pricePoint!) {
      setState(() {
        _isClaim = false;
      });
    } else {
      setState(() {
        _isClaim = true;
      });
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setStates) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Container(
                            height: 5,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: ColorPalette.neutral_30),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.24,
                            imageUrl: prizeDataDetail.photo == null
                                ? ""
                                : imageUrl + prizeDataDetail.photo!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/image/default_image.png',
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            prizeDataDetail.prize!,
                            style: const TextStyle(
                              fontSize: 24,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Html(data: prizeDataDetail.description ?? ''),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Makin banyak star, makin gede peluangnya!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorPalette.darkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorPalette.surface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icon/ic_danger.png',
                                width: 14,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Text(
                                  _isClaim
                                      ? 'Jangan khawatir SoulMet! Star point kamu akan dikembalikan jika nomor voucher undian kamu tidak terpilih.'
                                      : 'Yah, star point kamu belum cukup nih buat ambil undian ini. Tambah star point kamu dengan main mini games atau quiz.',
                                  style: const TextStyle(
                                    color: ColorPalette.mainColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Jumlah Voucher",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => minus(setStates),
                                      onLongPress: () => allInMin(setStates),
                                      child: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              top: 12,
                                              bottom: 12,
                                              right: 12),
                                          child: Icon(Icons.remove)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorPalette.neutral_30,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(
                                        IsilahHelper
                                            .formatCurrencyWithoutSymbol(
                                                _totalValue.toDouble()),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: ColorPalette.neutral_90,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => add(setStates),
                                      onLongPress: () => allIn(setStates),
                                      child: const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Icon(Icons.add_rounded)),
                                    ),
                                  ],
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
                            if (_isClaim) {
                              Navigator.pop(context);
                              checkDomisili(_initialValue, _totalValue,
                                  prizeDataDetail.prizeId!);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _isClaim
                                  ? ColorPalette.mainColor
                                  : ColorPalette.colorTextDisable,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icon/ic_star_single.png',
                                      width: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        IsilahHelper
                                            .formatCurrencyWithoutSymbol(
                                                _initialValue.toDouble()),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  "Klaim",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void minus(StateSetter updateState) {
    if (canDoAction(DoAction.minus)) {
      updateState(() {
        _totalValue--;
        _initialValue -= _stepValue;
      });
    }
  }

  void add(StateSetter updateState) {
    if (canDoAction(DoAction.add)) {
      updateState(() {
        _totalValue++;
        _initialValue += _stepValue;
      });
    }
  }

  void allInMin(StateSetter updateState) {
    updateState(() {
      _totalValue = 1;
      _initialValue = _stepValue;
    });
  }

  void allIn(StateSetter updateState) {
    for (var i = _initialValue; i < _maxValue; i += _stepValue) {
      updateState(() {
        _initialValue = i;
      });
    }

    if ((_maxValue / _stepValue).floor() != 0) {
      updateState(() {
        _totalValue = (_maxValue / _stepValue).floor();
      });
    }
  }

  bool canDoAction(DoAction action) {
    if (action == DoAction.minus) {
      return _initialValue - _stepValue >= _minValue;
    }
    if (action == DoAction.add) {
      return _initialValue + _stepValue <= _maxValue;
    }
    return false;
  }

  void checkDomisili(int prizeValue, int quantity, int prizeId) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: _isLoadingClaim,
        enableDrag: _isLoadingClaim,
        backgroundColor: Colors.white,
        builder: (builder) {
          return StatefulBuilder(builder: (ctx, setStates) {
            return WillPopScope(
              onWillPop: () async {
                Map<String, dynamic> basket =
                    Provider.of(context, listen: false);
                setStates(() {
                  basket['receiverName'] = null;
                  basket['phone'] = null;
                  basket['postalCode'] = null;
                  basket['address'] = null;
                  basket['idProvince'] = null;
                  basket['idCity'] = null;
                  basket['idSubdistrict'] = null;
                  basket['idUrbanVillage'] = null;
                  basket['nameProfesi'] = null;
                  basket['nameProvince'] = null;
                  basket['nameCity'] = null;
                  basket['nameSubdistrict'] = null;
                  basket['nameUrbanVillage'] = null;
                  addressDetail = null;
                });
                return true;
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: Container(
                              height: 5,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: ColorPalette.neutral_30),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/icon/ic_address_book.png',
                              width: 64,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Sebelum lanjut, Pastiin dulu data diri kamu udah sesuai',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Nama',
                            style: TextStyle(
                              color: ColorPalette.neutral_70,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            receiverNameShow == null
                                ? '${auth.currentUser!.data!.user!.fullName}'
                                : receiverNameShow!,
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'Nomor HP',
                            style: TextStyle(
                              color: ColorPalette.neutral_70,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            phoneShow == null
                                ? '+62${auth.currentUser!.data!.user!.phone}'
                                : '+62$phoneShow',
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'Alamat',
                            style: TextStyle(
                              color: ColorPalette.neutral_70,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            addressDetailShow == null
                                ? '${auth.currentUser!.data!.user!.address},\n${auth.currentUser!.data!.user!.urbanVillage}, ${auth.currentUser!.data!.user!.subdistrict}, ${auth.currentUser!.data!.user!.regency}, ${auth.currentUser!.data!.user!.province} ${auth.currentUser!.data!.user!.postalCode}'
                                : addressDetailShow!,
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: bodyMedium,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> basket =
                                        Provider.of(context, listen: false);
                                    setStates(() {
                                      basket['receiverName'] =
                                          basket['receiverName'] ??
                                              auth.currentUser!.data!.user!
                                                  .fullName;
                                      basket['phone'] = basket['phone'] ??
                                          auth.currentUser!.data!.user!.phone;
                                      basket['postalCode'] =
                                          basket['postalCode'] ??
                                              auth.currentUser!.data!.user!
                                                  .postalCode;
                                      basket['address'] = basket['address'] ??
                                          '${auth.currentUser!.data!.user!.address}';
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const UbahDataPengirimanPage();
                                    })).then((val) => val
                                        ? setAddressDetail(setStates)
                                        : null);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorPalette.mainColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Eh, ada yang salah',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorPalette.mainColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: _isLoadingClaim
                                    ? GestureDetector(
                                        onTap: () {
                                          _postClaimStepOne(
                                              prizeId, quantity, setStates);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: ColorPalette.mainColor,
                                            border: Border.all(
                                                color: ColorPalette.mainColor),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Udah Sesuai',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const ButtonLoadingWidget(
                                        color: ColorPalette.mainColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        }).whenComplete(() {
      Map<String, dynamic> basket = Provider.of(context, listen: false);
      setState(() {
        basket['receiverName'] = null;
        basket['phone'] = null;
        basket['postalCode'] = null;
        basket['address'] = null;
        basket['idProvince'] = null;
        basket['idCity'] = null;
        basket['idSubdistrict'] = null;
        basket['idUrbanVillage'] = null;
        basket['nameProfesi'] = null;
        basket['nameProvince'] = null;
        basket['nameCity'] = null;
        basket['nameSubdistrict'] = null;
        basket['nameUrbanVillage'] = null;
        addressDetail = null;
      });
    });
  }

  Future<void> setAddressDetail(StateSetter setStates) async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    setStates(() {
      addressDetail =
          basket['address'] ?? auth.currentUser!.data!.user!.address;
      postalCode =
          basket['postalCode'] ?? auth.currentUser!.data!.user!.postalCode;
      var province =
          basket['nameProvince'] ?? auth.currentUser!.data!.user!.province;
      var city = basket['nameCity'] ?? auth.currentUser!.data!.user!.regency;
      var subdistrict = basket['nameSubdistrict'] ??
          auth.currentUser!.data!.user!.subdistrict;
      var urbanVillage = basket['nameUrbanVillage'] ??
          auth.currentUser!.data!.user!.urbanVillage;
      addressDetailShow = addressDetail ==
              "$province, $city, $subdistrict, $urbanVillage, $postalCode"
          ? "$addressDetail"
          : '$addressDetail,\n$province, $city, $subdistrict, $urbanVillage $postalCode';
      receiverNameShow =
          basket['receiverName'] ?? auth.currentUser!.data!.user!.fullName;
      phoneShow = basket['phone'] ?? auth.currentUser!.data!.user!.phone;
    });
  }
}

enum DoAction { minus, add }
