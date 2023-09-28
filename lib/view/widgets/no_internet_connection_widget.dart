import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  final Function()? function;
  const NoInternetConnectionWidget({Key? key, @required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 46,
        ),
        Image.asset(
          'assets/image/img_no_connection.png',
          width: 200,
        ),
        const SizedBox(
          height: 24,
        ),
        const Text(
          'Tidak Ada Koneksi Internet',
          style: TextStyle(
              color: ColorPalette.neutral_90,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          'Coba cek koneksi internet kamu dan coba lagi',
          style: TextStyle(
              color: ColorPalette.neutral_70,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
        GestureDetector(
          onTap: function,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: ColorPalette.mainColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/ic_reload.png',
                  width: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Refresh',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
