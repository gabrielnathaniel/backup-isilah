import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isilahtitiktitik/bloc/funfacts-bloc/fun_fact_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/fun_fact.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-fun-fact/page_detail_fun_fact.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FunFactPage extends StatefulWidget {
  const FunFactPage({Key? key}) : super(key: key);

  @override
  State<FunFactPage> createState() => _FunFactPageState();
}

class _FunFactPageState extends State<FunFactPage> {
  bool status = false;

  final FunFactBloc _funFactBloc = FunFactBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<DataFunFact> _listData = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadMoreData(true, false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreData(false, false);
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _funFactBloc.close();
  }

  Future<void> _loadMoreData(bool statusLoad, bool isRefresh) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    _funFactBloc.add(GetFunFact(
        http: chttp,
        statusLoad: statusLoad,
        page: pageNumber,
        isRefresh: isRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/image/img_background_appbar.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tau Gak?',
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: bodyMedium,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (context) => _funFactBloc,
        child:
            BlocBuilder<FunFactBloc, FunFactState>(builder: (context, state) {
          if (state is FunFactInitial) {
            return const LoadingWidget();
          } else if (state is FunFactLoading) {
            return const LoadingWidget();
          } else if (state is FunFactLoaded || state is FunFactMoreLoading) {
            if (state is FunFactLoaded) {
              _listData = state.list;
              _currentLenght = state.count;
              _limit = state.limit;
            }
            return _buildBody(state);
          } else if (state is FunFactError) {
            Logger().d("Error Fun Fact : ${state.message}");
            return state.message == 'Not connected'
                ? NoInternetConnectionWidget(function: () {
                    setState(() {
                      pageNumber = 1;
                      _limit = 1;
                    });
                    _loadMoreData(true, true);
                  })
                : Container();
          }

          return Container();
        }),
      ),
    );
  }

  Widget _buildBody(FunFactState state) {
    if (_listData.isEmpty) {
      return Container();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          pageNumber = 1;
          _limit = 1;
          _currentLenght = 0;
        });

        _loadMoreData(true, true);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._listData
                .map(
                  (data) => SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8, top: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: ColorPalette.neutral_30)),
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
                                    MediaQuery.of(context).size.height * 0.22,
                                fit: BoxFit.cover,
                                imageUrl: data.thumbnail!,
                                placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.22,
                                  ),
                                )),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/image/default_image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title!,
                                  style: const TextStyle(
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data.contentThumbnail!,
                                  style: const TextStyle(
                                      color: ColorPalette.neutral_80,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.5),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            (state is FunFactMoreLoading)
                ? const Center(
                    child: SpinKitThreeBounce(
                    color: ColorPalette.mainColor,
                    size: 30.0,
                  ))
                : const SizedBox(),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
