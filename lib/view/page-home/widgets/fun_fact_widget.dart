import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/funfacts-bloc/fun_fact_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/fun_fact.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-fun-fact/page_detail_fun_fact.dart';
import 'package:isilahtitiktitik/view/widgets/loading_funfact_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FunFactWidget extends StatefulWidget {
  final String? title;
  final int? id;
  const FunFactWidget({Key? key, @required this.title, this.id})
      : super(key: key);

  @override
  State<FunFactWidget> createState() => _FunFactWidgetState();
}

class _FunFactWidgetState extends State<FunFactWidget> {
  FunFactBloc funFactBloc = FunFactBloc();

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    funFactBloc.add(GetFunFactCaraousel(http: chttp));
    super.initState();
  }

  @override
  void dispose() {
    funFactBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FunFactBloc>(
      create: (context) => funFactBloc,
      child: _buildFunFacts(),
    );
  }

  Widget _buildFunFacts() {
    return BlocBuilder<FunFactBloc, FunFactState>(
      builder: (context, state) {
        if (state is FunFactInitial) {
          return loadingFunFactWidget(context);
        } else if (state is FunFactCarouselLoading) {
          return loadingFunFactWidget(context);
        } else if (state is FunFactCarouselLoaded) {
          return _buildListFunFacts(context, state.factModel);
        } else if (state is FunFactCarouselError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildListFunFacts(BuildContext context, FunFactModel funFactModel) {
    var dataList = widget.id == null
        ? funFactModel.data!.data!.toList()
        : funFactModel.data!.data!
            .where(
              (element) => element.id != widget.id,
            )
            .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 16,
                  color: ColorPalette.neutral_90,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/fun-fact');
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: bodySmall,
                    color: ColorPalette.darkBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...dataList
                  .map(
                    (data) => Container(
                      margin:
                          const EdgeInsets.only(right: 8, bottom: 16, left: 8),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 6.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              0.0, // Move to right 10  horizontally
                              3.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailFunFactPage(
                                        idFunFact: data.id,
                                      )));
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                                imageUrl: data.thumbnail ?? '',
                                placeholder: (context, url) => Center(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/image/default_image.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    IsilahHelper.removeAllHtmlTags(
                                        data.contentThumbnail!),
                                    style: const TextStyle(
                                        color: ColorPalette.neutral_80,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        height: 1.5),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
