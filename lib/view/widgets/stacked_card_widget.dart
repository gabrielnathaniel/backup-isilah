import 'package:flutter/material.dart';

class StackOfCards extends StatelessWidget {
  final int num;
  final Widget? child;
  final double? offset;

  const StackOfCards(
      {Key? key, int num = 1, @required this.child, this.offset = 10.0})
      : num = num > 0 ? num : 1,
        assert(offset != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: List<Widget>.generate(
            num - 1,
            (val) => Positioned(
                bottom: val * offset!,
                left: (num - val - 1) * offset!,
                top: (num - val - 1) * offset!,
                right: (num - val - 1) * offset!,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                ))).toList()
          ..add(
            Padding(
              padding: EdgeInsets.only(
                bottom: (num - 1) * offset!,
              ),
              child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: child),
            ),
          ),
      );
}
