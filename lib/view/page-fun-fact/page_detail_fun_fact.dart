import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:isilahtitiktitik/bloc/funfacts-bloc/fun_fact_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/detail_fun_fact.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/content_view.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/fun_fact_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailFunFactPage extends StatefulWidget {
  final int? idFunFact;
  const DetailFunFactPage({Key? key, this.idFunFact}) : super(key: key);

  @override
  State<DetailFunFactPage> createState() => _DetailFunFactPageState();
}

class _DetailFunFactPageState extends State<DetailFunFactPage> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  FunFactBloc funFactBloc = FunFactBloc();

  Future<void> urlFileShare(String url, String? title, String? desc) async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    var response = await get(Uri.parse(url));
    final documentDirectory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$documentDirectory/images.png');
    imgFile.writeAsBytesSync(response.bodyBytes);

    Share.shareXFiles([XFile(imgFile.path)],
        subject: title,
        text: auth.currentUser!.data!.user!.id == 11
            ? "Fun Facts $title, banyak yang menarik di isilah yuk download sekarang juga"
            : "Fun Facts $title, banyak yang menarik di isilah yuk download sekarang di https://isilah.com",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (160 - kToolbarHeight);
  }

  @override
  void initState() {
    getDetailFunFact();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      setState(() {
        _scrollListener();
      });
    });
    super.initState();
  }

  void getDetailFunFact() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    funFactBloc.add(GetDetailFunFact(http: chttp, id: widget.idFunFact));
  }

  @override
  void dispose() {
    funFactBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => funFactBloc,
          child: BlocBuilder<FunFactBloc, FunFactState>(
            builder: (context, state) {
              if (state is FunFactInitial) {
                return const LoadingWidget();
              } else if (state is DetailFunFactLoading) {
                return const LoadingWidget();
              } else if (state is DetailFunFactLoaded) {
                return _buildData(context, state.detailFunFactModel);
              } else if (state is DetailFunFactError) {
                Logger().d("Error Fun Fact : ${state.message}");
                return state.message == 'Not connected'
                    ? NoInternetConnectionWidget(function: () {
                        getDetailFunFact();
                      })
                    : Container();
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildData(
      BuildContext context, DetailFunFactModel detailFunFactModel) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: isShrink ? ColorPalette.neutral_90 : Colors.white,
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Center(
              child: Platform.isIOS
                  ? Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: isShrink
                          ? const Icon(Icons.arrow_back_ios,
                              size: 20, color: ColorPalette.neutral_90)
                          : const Icon(Icons.arrow_back_ios,
                              size: 20, color: Colors.white),
                    )
                  : isShrink
                      ? const Icon(
                          Icons.arrow_back,
                          color: ColorPalette.neutral_90,
                          size: 20,
                        )
                      : Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(Icons.arrow_back,
                                size: 20, color: Colors.white),
                          )),
            ),
          ),
          pinned: true,
          expandedHeight: MediaQuery.of(context).size.height * 0.23,
          floating: true,
          centerTitle: false,
          title: Text(
            isShrink ? '${detailFunFactModel.data!.title}' : '',
            style: TextStyle(
                fontSize: titleSmall,
                color: isShrink ? ColorPalette.neutral_90 : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          titleSpacing: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: detailFunFactModel.data!.thumbnail!,
                          placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/image/default_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: ColorPalette.neutral_90.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                    child: Container(
                  height: 15,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorPalette.neutral_90.withOpacity(0.1),
                        spreadRadius: 25,
                        blurRadius: 30,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    // color: ColorPalette.neutral_9054
                  ),
                )),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                urlFileShare(
                    detailFunFactModel.data!.thumbnail!,
                    detailFunFactModel.data!.title!,
                    IsilahHelper.removeAllHtmlTags(
                        detailFunFactModel.data!.content!));
              },
              child: isShrink
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(
                        child: Icon(
                          Icons.share,
                          size: 20,
                          color: ColorPalette.neutral_90,
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
            )
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${detailFunFactModel.data!.title}",
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          detailFunFactModel.data!.userPhoto == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/image/default_profile.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        detailFunFactModel.data!.userPhoto!,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/image/default_profile.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              "${detailFunFactModel.data!.fullName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                IsilahHelper.formatDayMonthYear(
                                    detailFunFactModel.data!.date!),
                                style: const TextStyle(
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Icon(
                                Icons.circle,
                                size: 4,
                                color: ColorPalette.neutral_70,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Baca ${detailFunFactModel.data!.duration == null ? 0 : detailFunFactModel.data!.duration.toString()} Menit',
                                style: const TextStyle(
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Html(
                        data: detailFunFactModel.data!.content!,
                        style: {
                          'p': Style(
                              color: ColorPalette.neutral_80,
                              textAlign: TextAlign.justify,
                              lineHeight: LineHeight.number(1.2))
                        },
                        onLinkTap: (url, _, __, ___) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWebview(
                                        url: url,
                                        title: "Fun Fact",
                                      )));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Tags:",
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        direction: Axis.horizontal,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ...detailFunFactModel.data!.tags!
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorPalette.neutral_20,
                                  ),
                                  child: Text(
                                    tag.name!,
                                    style: const TextStyle(
                                      color: ColorPalette.neutral_80,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: ColorPalette.neutral_30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.width * 0.3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    detailFunFactModel.data!.userPhoto == null
                                        ? ""
                                        : detailFunFactModel.data!.userPhoto!,
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/image/default_image.png',
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    detailFunFactModel.data!.fullName!,
                                    style: const TextStyle(
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    detailFunFactModel.data!.bio == null
                                        ? 'Jangan lupa difollow ya'
                                        : detailFunFactModel.data!.bio!,
                                    style: const TextStyle(
                                      color: ColorPalette.neutral_80,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWebview(
                                                        url: detailFunFactModel
                                                                .data!
                                                                .socmedIg ??
                                                            "https://www.instagram.com/",
                                                        title: "Source",
                                                      )));
                                        },
                                        child: Image.asset(
                                          'assets/icon/ic_ig.png',
                                          width: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWebview(
                                                        url: detailFunFactModel
                                                                .data!
                                                                .socmedTw ??
                                                            "https://twitter.com/",
                                                        title: "Source",
                                                      )));
                                        },
                                        child: Image.asset(
                                          'assets/icon/ic_twitter.png',
                                          width: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWebview(
                                                        url: detailFunFactModel
                                                                .data!
                                                                .socmedFb ??
                                                            "https://www.facebook.com/",
                                                        title: "Source",
                                                      )));
                                        },
                                        child: Image.asset(
                                          'assets/icon/ic_fb_grey.png',
                                          width: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FunFactWidget(
                      title: 'Fun Facts Lainnya',
                      id: widget.idFunFact,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
