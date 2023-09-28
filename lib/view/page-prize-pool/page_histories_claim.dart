import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/resource/prize_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HistoriesClaimPage extends StatefulWidget {
  const HistoriesClaimPage({Key? key}) : super(key: key);

  @override
  State<HistoriesClaimPage> createState() => _HistoriesClaimPageState();
}

class _HistoriesClaimPageState extends State<HistoriesClaimPage> {
  final textEditingSearch = TextEditingController();

  List _listData = [];

  int _pageNumber = 1;

  String? searchKey;
  String _sortBy = "date";
  String _sort = "desc";
  String? _status;

  late ScrollController _scrollController;

  int _sortIndex = 0;
  int _filterIndex = 1;
  int _lastIndex = 0;
  String filterStatus = 'Semua Status';

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  void _firstLoad() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    PrizeApi prizeApi = PrizeApi(http: chttp);

    setState(() {
      _hasNextPage = true;
      _isFirstLoadRunning = true;
      _pageNumber = 1;
      _listData.clear();
    });

    prizeApi
        .fetchHistoriesClaim(
            _pageNumber, searchKey ?? "", _sortBy, _sort, _status)
        .then((value) {
      setState(() {
        _listData = value.data!.data!;
        _isFirstLoadRunning = false;
        _lastIndex = value.data!.total!;
      });
    }).catchError((onError) {
      setState(() {
        _isFirstLoadRunning = false;
      });
      flushbarError(onError['message']['title']).show(context);
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    PrizeApi prizeApi = PrizeApi(http: chttp);

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _pageNumber += 1;

      prizeApi
          .fetchHistoriesClaim(
              _pageNumber, searchKey ?? "", _sortBy, _sort, _status)
          .then((value) {
        final List fetchedPosts = value.data!.data!;
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _listData.addAll(fetchedPosts);
          });
        } else {
          // End of list
          setState(() {
            _hasNextPage = false;
          });
        }
      }).catchError((onError) {
        flushbarError(onError['message']['title']).show(context);
      });

      // setState(() {
      _isLoadMoreRunning = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const HomeWidget(
            initialIndex: 2,
            showBanner: false,
          );
        }), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: const Image(
            image: AssetImage('assets/image/img_background_appbar.png'),
            fit: BoxFit.fitWidth,
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Riwayat Klaim',
            style: TextStyle(
                fontSize: titleSmall,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const HomeWidget(
                    initialIndex: 2,
                    showBanner: false,
                  );
                }), (Route<dynamic> route) => false);
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: ListView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: textEditingSearch,
                        cursorColor: ColorPalette.mainColor,
                        onChanged: (value) async {
                          setState(() {
                            searchKey = value;
                          });
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          _firstLoad();
                        },
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w500,
                          fontSize: bodyMedium,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorPalette.neutral_20,
                          hintText: 'Cari nama hadiah',
                          hintStyle: const TextStyle(
                            color: ColorPalette.neutral_70,
                            fontWeight: FontWeight.w400,
                            fontSize: bodyMedium,
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            fontSize: bodySmall,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            size: 24,
                            color: ColorPalette.neutral_70,
                          ),
                          contentPadding: const EdgeInsets.only(
                              bottom: 8, top: 8, right: 12, left: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorPalette.neutral_40),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.red)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: ColorPalette.mainColor)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        keyboardType: TextInputType.text),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSorting();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28, right: 6),
                      child: Image.asset(
                        "assets/icon/ic_sort.png",
                        width: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  showFilter();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      filterStatus,
                      style: const TextStyle(
                        color: ColorPalette.neutral_90,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: ColorPalette.neutral_70,
                    )
                  ],
                ),
              ),
            ),
            _isFirstLoadRunning
                ? const Center(
                    child: SizedBox(
                        height: 300,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: LoadingWidget())))
                : _buildHistoriesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoriesList() {
    if (_listData.isEmpty) {
      return Center(
        child: _isFirstLoadRunning
            ? const CircularProgressIndicator(
                color: ColorPalette.mainColor,
              )
            : EmptyStateWidget(
                sizeWidth: 200,
                title: textEditingSearch.text.isNotEmpty
                    ? 'Kode Kupon Yang Kamu Cari Gaada'
                    : 'Hadiah Kamu Belum Ada',
                subTitle: textEditingSearch.text.isNotEmpty
                    ? 'Coba pastiin kode kupon kamu sudah benar'
                    : 'Yuk main dan kumpulin star buat klaim hadiah kamu',
              ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: _listData.length + 1,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        if (_listData.length == index) {
          return _listData.length == _lastIndex
              ? Container()
              : const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                      child: SpinKitThreeBounce(
                    color: ColorPalette.mainColor,
                    size: 30.0,
                  )),
                );
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: ColorPalette.neutral_30),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _listData[index].photo == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/image/default_image.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        imageUrl: _listData[index].photo!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
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
                                  borderRadius: BorderRadius.circular(16)),
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      _listData[index].date == null
                          ? '-'
                          : IsilahHelper.formatDaysFull(_listData[index].date),
                      style: const TextStyle(
                          color: ColorPalette.neutral_70,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${_listData[index].prize}",
                      style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icon/ic_star_36.png',
                          width: 16,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          IsilahHelper.formatCurrencyWithoutSymbol(
                                  double.parse(_listData[index].pricePoint!))
                              .toString(),
                          style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_listData[index].status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getStatusIcon(_listData[index].status),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: _getStatusText(_listData[index].status,
                                    _listData[index].drawnOn),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Kode Kupon',
                        style: TextStyle(
                            color: ColorPalette.neutral_70,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_listData[index].code}',
                            style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Clipboard.setData(ClipboardData(
                                      text: _listData[index].code))
                                  .then((value) {
                                Flushbar(
                                  message:
                                      'Kode kupon telah disalin di papan klip',
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: BorderRadius.circular(8),
                                  duration: const Duration(seconds: 2),
                                  messageSize: 12,
                                  backgroundColor: ColorPalette.greenColor,
                                ).show(context);
                              });
                            },
                            child: Image.asset(
                              'assets/icon/ic_copy.png',
                              width: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showSorting() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, StateSetter updateStates) {
            return Container(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: ColorPalette.neutral_30),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      "Urutkan",
                      style: TextStyle(
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        customRadioButtonSort(1, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Tanggal Terbaru",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        customRadioButtonSort(2, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "A-Z",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_sortIndex != 0) {
                          Navigator.pop(context);
                          _firstLoad();
                        }
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _sortIndex == 0
                                ? ColorPalette.neutral_50
                                : ColorPalette.mainColor),
                        child: const Center(
                            child: Text(
                          'Terapkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showFilter() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, StateSetter updateStates) {
            return Container(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: ColorPalette.neutral_30),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      "Filter Status",
                      style: TextStyle(
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        customRadioButtonFilter(1, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Semua Status",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        customRadioButtonFilter(2, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Menunggu Undian",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        customRadioButtonFilter(3, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Berhasil Menang",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        customRadioButtonFilter(4, updateStates),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Belum Beruntung",
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_filterIndex != 0) {
                          Navigator.pop(context);
                          _firstLoad();
                        }
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _filterIndex == 0
                                ? ColorPalette.neutral_50
                                : ColorPalette.mainColor),
                        child: const Center(
                            child: Text(
                          'Terapkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 4:
        return ColorPalette.success;
      case -1:
        return ColorPalette.danger;
    }
    return ColorPalette.surface;
  }

  Widget _getStatusIcon(int status) {
    switch (status) {
      case 4:
        return const Icon(
          Icons.check_rounded,
          size: 12,
          color: Colors.white,
        );
      case -1:
        return const Icon(
          Icons.close_rounded,
          size: 12,
          color: Colors.white,
        );
    }
    return Container();
  }

  Text _getStatusText(int status, String? dateTime) {
    switch (status) {
      case 4:
        return const Text(
          'Selamat! Kamu berhasil dapet hadiahnya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        );
      case -1:
        return const Text(
          'Kamu Belum Beruntung',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        );
    }
    return Text(
      'Diundi Tanggal ${dateTime == null ? '-' : IsilahHelper.formatDays(dateTime)}',
      style: const TextStyle(
        color: ColorPalette.mainColor,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget customRadioButtonSort(int index, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortIndex = index;
          _sortBy = index == 1 ? "date" : "prize";
          _sort = index == 1 ? "desc" : "asc";
        });
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.neutral_90, width: 1),
            borderRadius: BorderRadius.circular(60)),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: _sortIndex == index
                    ? ColorPalette.neutral_90
                    : Colors.white,
                borderRadius: BorderRadius.circular(60)),
          ),
        ),
      ),
    );
  }

  Widget customRadioButtonFilter(int index, StateSetter setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterIndex = index;
          switch (index) {
            case 1:
              filterStatus = 'Semua Status';
              _status = null;
              break;
            case 2:
              filterStatus = 'Menunggu Undian';
              _status = '0';
              break;
            case 3:
              filterStatus = 'Berhasil Menang';
              _status = '4';
              break;
            case 4:
              filterStatus = 'Belum Beruntung';
              _status = '-1';
              break;
            default:
          }
        });
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.neutral_90, width: 1),
            borderRadius: BorderRadius.circular(60)),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: _filterIndex == index
                    ? ColorPalette.neutral_90
                    : Colors.white,
                borderRadius: BorderRadius.circular(60)),
          ),
        ),
      ),
    );
  }
}
