import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/single-user-rank-bloc/single_user_rank_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/single_rank.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/widgets/loading_single_rank_widget.dart';
import 'package:shimmer/shimmer.dart';

class SingleUserRankByTypeWidget extends StatefulWidget {
  final String? type;
  const SingleUserRankByTypeWidget({Key? key, @required this.type})
      : super(key: key);

  @override
  State<SingleUserRankByTypeWidget> createState() =>
      _SingleUserRankByTypeWidgetState();
}

class _SingleUserRankByTypeWidgetState
    extends State<SingleUserRankByTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserRankBloc, SingleUserRankState>(
      builder: (context, state) {
        if (state is SingleUserRankInitial) {
          return const LoadingSingleRankWidget();
        } else if (state is SingleUserRankLoading) {
          return const LoadingSingleRankWidget();
        } else if (state is SingleUserRankLoaded) {
          return _buildBody(context, state.singleUserRanksModel);
        } else if (state is SingleUserRankError) {
          // return _buildEmptyCart();
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildBody(
      BuildContext context, SingleUserRanksModel? singleUserRanksModel) {
    return singleUserRanksModel == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 30),
                child: Text(
                  'Ranking Saya',
                  style: TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w500,
                    fontSize: bodyMedium,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        IsilahHelper.formatCurrencyWithoutSymbol(
                            singleUserRanksModel.data!.rank == null
                                ? 0
                                : singleUserRanksModel.data!.rank!.toDouble()),
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    singleUserRanksModel.data!.photo == null
                        ? Image.asset(
                            'assets/image/default_profile.png',
                            width: 32,
                          )
                        : CachedNetworkImage(
                            width: 32,
                            height: 32,
                            imageUrl:
                                imageUrl + singleUserRanksModel.data!.photo!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
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
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            )),
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
                        singleUserRanksModel.data!.username == null
                            ? ""
                            : singleUserRanksModel.data!.username!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      singleUserRanksModel.data!.experience == null
                          ? "-"
                          : "${IsilahHelper.formatCurrencyWithoutSymbol(double.parse(singleUserRanksModel.data!.experience!))} Exp",
                      style: const TextStyle(
                        color: ColorPalette.mainColor,
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
