import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/undian-bloc/undian_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/undian.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-undian/page_pemenang_undian.dart';
import 'package:isilahtitiktitik/view/page-undian/page_undian.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UndianWidget extends StatefulWidget {
  final String? title;
  const UndianWidget({Key? key, this.title}) : super(key: key);

  @override
  State<UndianWidget> createState() => _UndianWidgetState();
}

class _UndianWidgetState extends State<UndianWidget> {
  UndianBloc undianBloc = UndianBloc();

  List<int> listShimmer = [1, 2, 3, 4];

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    undianBloc.add(GetUndian(http: chttp));

    super.initState();
  }

  @override
  void dispose() {
    undianBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => undianBloc,
      child: BlocBuilder<UndianBloc, UndianState>(
        builder: (context, state) {
          if (state is UndianInitial) {
            return _loading();
          } else if (state is UndianLoading) {
            return _loading();
          } else if (state is UndianLoaded) {
            return _buildBody(context, state.undianModel);
          } else if (state is UndianError) {
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

  Widget _buildBody(BuildContext context, UndianModel? undianModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                style: TextStyle(
                  fontSize: widget.title == 'Pemenang Undian' ? bodyMedium : 16,
                  color: ColorPalette.neutral_90,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UndianPage()));
                },
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: bodySmall,
                    color: ColorPalette.darkBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...undianModel!.data!.data!
                  .where((element) => element.drawnOn != null)
                  .take(5)
                  .map((undian) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PemenangUndianPage(
                                    drawnOn: undian.drawnOn,
                                  )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              undian.photo == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        "assets/image/default_image.png",
                                        height: 118,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 118,
                                        imageUrl: undian.photo!,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                              height: 118,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/image/default_image.png',
                                          fit: BoxFit.cover,
                                          height: 118,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Undian ${IsilahHelper.formatDaysUndian(undian.drawnOn!)}",
                                style: const TextStyle(
                                  color: ColorPalette.neutral_90,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Siapa nih, pemenang ${IsilahHelper.formatDaysUndian(undian.drawnOn!)}",
                                style: const TextStyle(
                                  color: ColorPalette.neutral_70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  Widget _loading() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: 100,
                    height: 15,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: 80,
                    height: 15,
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 17,
        ),
        SingleChildScrollView(
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
        ),
      ],
    );
  }
}
