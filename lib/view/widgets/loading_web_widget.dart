import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';

class LoadingWebWidget extends StatelessWidget {
  const LoadingWebWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const widget = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.mainColor),
    );
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget,
          SizedBox(
            height: 8,
          ),
          Text(
            "Mohon Tunggu...",
            style: TextStyle(
              color: ColorPalette.mainColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          )
        ],
      )),
    );
  }
}
