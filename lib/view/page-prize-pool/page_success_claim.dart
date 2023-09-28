import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/claim_finish.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_histories_claim.dart';
import 'package:shimmer/shimmer.dart';

class SuccessClaimPage extends StatefulWidget {
  final List<ClaimFinishData>? listClaim;
  const SuccessClaimPage({
    Key? key,
    this.listClaim,
  }) : super(key: key);

  @override
  State<SuccessClaimPage> createState() => _SuccessClaimPageState();
}

class _SuccessClaimPageState extends State<SuccessClaimPage> {
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
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            flexibleSpace: const Image(
              image: AssetImage('assets/image/img_bg_status_bar.png'),
              fit: BoxFit.fitWidth,
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Center(
                  child: Image.asset(
                    'assets/image/img_success_claim.png',
                    width: 250,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Center(
                  child: Text(
                    "Yes, Kupon Berhasil Diklaim!",
                    style: TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text(
                    "Kupon kamu sudah dimasukkan dalam undian, tunggu pengumumannya di instagram kita!",
                    style: TextStyle(
                      color: ColorPalette.neutral_70,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/ic_ig.png',
                      width: 18,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      "isilah.id",
                      style: TextStyle(
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HistoriesClaimPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: ColorPalette.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icon/ic_voucher.png',
                            width: 18,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Lihat Kode Kupon',
                            style: TextStyle(
                              color: ColorPalette.mainColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 42,
                ),
                const Text(
                  "Daftar Kupon",
                  style: TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 13,
                ),
                ...widget.listClaim!.map(
                  (data) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    height: 118,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorPalette.neutral_30),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        data.photo == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  "assets/image/default_image.png",
                                  height: 118,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  width: 118,
                                  height: 118,
                                  imageUrl: data.photo!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        width: 118,
                                        height: 118,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/image/default_image.png',
                                    fit: BoxFit.cover,
                                    width: 118,
                                    height: 118,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.prize}",
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
                                              double.parse(data.pricePoint!))
                                          .toString(),
                                      style: const TextStyle(
                                          color: ColorPalette.neutral_90,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const Expanded(
                                  child: SizedBox(
                                    height: 8,
                                  ),
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
                                        '${data.code}',
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
                                                  text: data.code!))
                                              .then((value) {
                                            Flushbar(
                                              message:
                                                  'Kode kupon telah disalin di papan klip',
                                              margin: const EdgeInsets.all(16),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              duration:
                                                  const Duration(seconds: 2),
                                              messageSize: 12,
                                              backgroundColor:
                                                  ColorPalette.greenColor,
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
