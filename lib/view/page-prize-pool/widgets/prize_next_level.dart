import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/prize-bloc/prize_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/prize.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PrizeNextLevelWidget extends StatefulWidget {
  const PrizeNextLevelWidget({Key? key}) : super(key: key);

  @override
  State<PrizeNextLevelWidget> createState() => _PrizeNextLevelWidgetState();
}

class _PrizeNextLevelWidgetState extends State<PrizeNextLevelWidget> {
  PrizeBloc prizeBloc = PrizeBloc();

  List<int> listShimmer = [1, 2, 3, 4];

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    prizeBloc.add(GetPrizeNextLevel(http: chttp, context: context));

    super.initState();
  }

  @override
  void dispose() {
    prizeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => prizeBloc,
      child: BlocBuilder<PrizeBloc, PrizeState>(
        builder: (context, state) {
          if (state is PrizeInitial) {
            return _loading();
          } else if (state is PrizeNextLevelLoading) {
            return _loading();
          } else if (state is PrizeNextLevelLoaded) {
            return _buildBody(
                context,
                state.prizeModel,
                state.experiencePercentage,
                state.experienceUser,
                state.levelUser);
          } else if (state is PrizeNextLevelError) {
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

  Widget _buildBody(BuildContext context, PrizeModel? prizeModel,
      int? experiencePercentage, int? experienceUser, String? levelUser) {
    if (prizeModel!.data!.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: EmptyStateWidget(
            sizeWidth: 200,
            title: 'Wah Kamu Keren',
            subTitle:
                "Karena kamu udah sampe level $levelUser jadi hadiah kamu udah mentok nih",
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          ...prizeModel.data!.data!
              .map((prizes) => Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                              width: double.infinity,
                              height: double.infinity,
                              imageUrl: imageUrl + prizes.photo!,
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
                              placeholder: (context, url) => Center(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/image/default_image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorPalette.neutral_90.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      height: double.infinity,
                                      width: double.infinity,
                                      imageUrl: imageUrl + prizes.levelLogo!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                                    BorderRadius.circular(8)),
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/image/default_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/icon/ic_lock.png',
                                        width: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                prizes.level!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: LinearProgressIndicator(
                                  value: (experiencePercentage! / 100),
                                  backgroundColor: Colors.white,
                                  minHeight: 6,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          ColorPalette.mainColor),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Butuh ${prizes.levelExperienceFrom! - experienceUser!} Exp lagi buat naik level!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _loading() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          ...listShimmer
              .map(
                (shim) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    width: MediaQuery.of(context).size.width * 0.6,
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
