import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';

class EmptyStateWidget extends StatefulWidget {
  final int sizeWidth;
  final String title;
  final String? subTitle;
  const EmptyStateWidget(
      {Key? key, required this.sizeWidth, required this.title, this.subTitle})
      : super(key: key);

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 46,
        ),
        Image.asset(
          'assets/image/img_empty_state.png',
          width: widget.sizeWidth.toDouble(),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          widget.title,
          style: const TextStyle(
              color: ColorPalette.neutral_90,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        widget.subTitle!.isEmpty
            ? Container()
            : Text(
                widget.subTitle!,
                style: const TextStyle(
                    color: ColorPalette.neutral_70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}
