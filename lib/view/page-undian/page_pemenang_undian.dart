import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:isilahtitiktitik/bloc/undian-bloc/undian_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/pemenang_undian.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PemenangUndianPage extends StatefulWidget {
  final String? drawnOn;
  const PemenangUndianPage({Key? key, this.drawnOn}) : super(key: key);

  @override
  State<PemenangUndianPage> createState() => _PemenangUndianPageState();
}

class _PemenangUndianPageState extends State<PemenangUndianPage> {
  UndianBloc undianBloc = UndianBloc();

  List<int> listShimmer = [1, 2, 3, 4, 5];

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    undianBloc.add(GetPemenangUndian(http: chttp, date: widget.drawnOn));

    super.initState();
  }

  @override
  void dispose() {
    undianBloc.close();
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
          'Pemenang Undian',
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
      body: BlocProvider(
        create: (context) => undianBloc,
        child: BlocBuilder<UndianBloc, UndianState>(
          builder: (context, state) {
            if (state is UndianInitial) {
              return _loading();
            } else if (state is PemenangUndianLoading) {
              return _loading();
            } else if (state is PemenangUndianLoaded) {
              return _buildBody(context, state.pemenangUndianModel);
            } else if (state is PemenangUndianError) {
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
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, PemenangUndianModel? pemenangUndianModel) {
    if (pemenangUndianModel!.data!.detail!.isEmpty) {
      return const Center(
        child: EmptyStateWidget(
          sizeWidth: 200,
          title: 'Pemenang Undian Belum Keluar Nih',
          subTitle: '',
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Undian Tanggal ${IsilahHelper.formatDaysUndian(widget.drawnOn!)}',
              style: const TextStyle(
                color: ColorPalette.neutral_90,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              '${pemenangUndianModel.data!.header!.description}',
              style: const TextStyle(
                color: ColorPalette.neutral_70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ...pemenangUndianModel.data!.detail!
                .map((data) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 8)),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                              color: ColorPalette.darkBlue,
                              borderRadius: BorderRadius.circular(6)),
                          child: Center(
                            child: data.photo == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/image/default_image.png",
                                      height: 80,
                                      width: 104,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      height: 80,
                                      width: 104,
                                      imageUrl: imageUrl + data.photo!,
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
                                                    BorderRadius.circular(16)),
                                            height: 80,
                                            width: 80,
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
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          data.prize!,
                          style: const TextStyle(
                            color: ColorPalette.neutral_90,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        data.winner!.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada pemenang',
                                  style: TextStyle(
                                    color: ColorPalette.neutral_60,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : StaggeredGrid.count(
                                crossAxisCount: data.winner!.length < 4 ? 1 : 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: [
                                  ...data.winner!
                                      .map(
                                        (winner) => StaggeredGridTile.fit(
                                          crossAxisCellCount: 1,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      ColorPalette.neutral_30,
                                                  width: 1),
                                            ),
                                            child: Text(
                                              winner.fullNameAsterix!,
                                              style: const TextStyle(
                                                color: ColorPalette.neutral_90,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
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
