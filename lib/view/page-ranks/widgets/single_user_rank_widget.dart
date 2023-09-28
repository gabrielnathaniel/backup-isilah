import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/single-user-bloc/single_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/widgets/loading_single_rank_widget.dart';
import 'package:shimmer/shimmer.dart';

class SingleUserRankWidget extends StatefulWidget {
  const SingleUserRankWidget({Key? key}) : super(key: key);

  @override
  State<SingleUserRankWidget> createState() => _SingleUserRankWidgetState();
}

class _SingleUserRankWidgetState extends State<SingleUserRankWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleUserBloc, SingleUserState>(
      builder: (context, state) {
        if (state is SingleUserInitial) {
          return const LoadingSingleRankWidget();
        } else if (state is SingleUserLoading) {
          return const LoadingSingleRankWidget();
        } else if (state is SingleUserLoaded) {
          return _buildBody(context, state.user);
        } else if (state is SingleUserError) {
          // return _buildEmptyCart();
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, User? user) {
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  IsilahHelper.formatCurrencyWithoutSymbol(
                      user!.data!.user!.rankExperience == null
                          ? 0
                          : user.data!.user!.rankExperience!.toDouble()),
                  style: const TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              user.data!.user!.photo == null
                  ? Image.asset(
                      'assets/image/default_profile.png',
                      width: 32,
                    )
                  : CachedNetworkImage(
                      width: 32,
                      height: 32,
                      imageUrl: imageUrl + user.data!.user!.photo!,
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
                  user.data!.user!.username == null
                      ? ""
                      : user.data!.user!.username!,
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
                "${IsilahHelper.formatCurrencyWithoutSymbol(user.data!.user!.experience!.toDouble())} Exp",
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
