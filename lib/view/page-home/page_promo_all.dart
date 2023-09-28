import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/promo-bloc/promo_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/promo.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/page_promo.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoAllPage extends StatefulWidget {
  const PromoAllPage({Key? key}) : super(key: key);

  @override
  State<PromoAllPage> createState() => _PromoAllPageState();
}

class _PromoAllPageState extends State<PromoAllPage> {
  PromoBloc promoBloc = PromoBloc();

  List<int> listShimmer = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    promoBloc.add(GetPromo(http: chttp));
  }

  @override
  void dispose() {
    promoBloc.close();
    super.dispose();
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
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Semua Event',
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
      body: BlocProvider<PromoBloc>(
        create: (context) => promoBloc,
        child: BlocBuilder<PromoBloc, PromoState>(
          builder: (context, state) {
            if (state is PromoInitial) {
              return _loading();
            } else if (state is GetPromoLoading) {
              return _loading();
            } else if (state is GetPromoLoaded) {
              return _buildBody(context, state.promoModel);
            } else if (state is GetPromoError) {
              return const Center(
                child: EmptyStateWidget(
                  sizeWidth: 200,
                  title: 'Oops!',
                  subTitle: 'Terjadi kesalahan, silahkan coba kembali',
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PromoModel? promoModel) {
    if (promoModel!.data!.data!.isEmpty) {
      return const Center(
        child: EmptyStateWidget(
          sizeWidth: 200,
          title: 'Belum Ada Event Nih :(',
          subTitle: 'Tungguin ya Event spesial dari mas slamet',
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Banyak hadiah dan event menarik yang jangan ampe kamu lewatin',
              style: TextStyle(
                color: ColorPalette.neutral_80,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildListData(promoModel)
          ],
        ),
      ),
    );
  }

  Widget _buildListData(PromoModel? promoModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...promoModel!.data!.data!
            .map(
              (data) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorPalette.neutral_30),
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () {
                    if (data.externalLink!.isNotEmpty) {
                      _launchInBrowser(Uri.parse(data.externalLink!));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromoPage(
                                    dataPromo: data,
                                  )));
                    }
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          width: double.infinity,
                          height: 158,
                          fit: BoxFit.cover,
                          imageUrl: data.thumbnail!,
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
                              color: Colors.white,
                              width: double.infinity,
                              height: 158,
                            ),
                          )),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/image/default_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "${IsilahHelper.formatDayAndMonth(data.publishAt!)} - ${IsilahHelper.formatDayAndMonth(data.publishTo!)}",
                          style: const TextStyle(
                            color: ColorPalette.neutral_80,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          data.title!,
                          style: const TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget _loading() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        children: [
          ...listShimmer
              .map(
                (shim) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    width: MediaQuery.of(context).size.width,
                    height: 118,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
