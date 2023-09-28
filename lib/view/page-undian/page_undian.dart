import 'dart:io';

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
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/loading_undian_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UndianPage extends StatefulWidget {
  const UndianPage({Key? key}) : super(key: key);

  @override
  State<UndianPage> createState() => _UndianPageState();
}

class _UndianPageState extends State<UndianPage> {
  UndianBloc undianBloc = UndianBloc();

  List<int> listShimmer = [1, 2, 3, 4, 5];

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
          'Undian',
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
              return LoadingUndianWidget();
            } else if (state is UndianLoading) {
              return LoadingUndianWidget();
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
      ),
    );
  }

  Widget _buildBody(BuildContext context, UndianModel? undianModel) {
    if (undianModel!.data!.data!.isEmpty) {
      return const Center(
        child: EmptyStateWidget(
          sizeWidth: 200,
          title: 'Jadwal Undian Belum Keluar Nih',
          subTitle: 'Tungguin ya undian - undian berikutnya dari mas slamet',
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          ...undianModel.data!.data!
              .where((element) => element.drawnOn != null)
              .map((data) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PemenangUndianPage(
                                drawnOn: data.drawnOn,
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.neutral_30),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          data.photo == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    "assets/image/default_image.png",
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    height: 80,
                                    width: 80,
                                    imageUrl: data.photo!,
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
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.drawnOn == null
                                      ? '-'
                                      : "Undian ${IsilahHelper.formatDaysUndian(data.drawnOn!)}",
                                  style: const TextStyle(
                                      color: ColorPalette.neutral_90,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  data.drawnOn == null
                                      ? ''
                                      : "Siapa nih, pemenang ${IsilahHelper.formatDaysUndian(data.drawnOn!)}",
                                  style: const TextStyle(
                                      color: ColorPalette.neutral_70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
}
