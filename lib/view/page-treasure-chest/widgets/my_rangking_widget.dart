import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/my-ranking-treasure-chest-bloc/my_ranking_treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/my_ranking_treasure_chest.dart';

class MyRankingTreasureChestWidget extends StatefulWidget {
  const MyRankingTreasureChestWidget({Key? key}) : super(key: key);

  @override
  State<MyRankingTreasureChestWidget> createState() =>
      _MyRankingTreasureChestWidgetState();
}

class _MyRankingTreasureChestWidgetState
    extends State<MyRankingTreasureChestWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildFunFacts();
  }

  Widget _buildFunFacts() {
    return BlocBuilder<MyRankingTreasureChestBloc, MyRankingTreasureChestState>(
      builder: (context, state) {
        if (state is MyRankingTreasureChestInitial) {
          return Container();
        } else if (state is MyRankingTreasureChestLoading) {
          return Container();
        } else if (state is MyRankingTreasureChestLoaded) {
          return _buildMyRangking(context, state.myRankingTreaseureChestModel!);
        } else if (state is MyRankingTreasureChestError) {
          // return _buildEmptyCart();
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMyRangking(BuildContext context,
      MyRankingTreaseureChestModel myRankingTreaseureChestModel) {
    return myRankingTreaseureChestModel.data == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Ranking Saya',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorPalette.neutral_90,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    color: ColorPalette.neutral_20,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.only(bottom: 8, top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(
                        myRankingTreaseureChestModel.data!.seq.toString(),
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    myRankingTreaseureChestModel.data!.photo == null
                        ? Image.asset(
                            'assets/image/default_profile.png',
                            width: 32,
                          )
                        : CachedNetworkImage(
                            width: 32,
                            height: 32,
                            imageUrl: imageUrl +
                                myRankingTreaseureChestModel.data!.photo!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image/default_profile.png',
                              width: 32,
                            ),
                          ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Text(
                        myRankingTreaseureChestModel.data!.username!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Text(
                      "${myRankingTreaseureChestModel.data!.answerCorrect} Benar",
                      style: const TextStyle(
                        color: ColorPalette.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
