import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
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
          'Voucher',
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: EmptyStateWidget(
            sizeWidth: 200,
            title: 'Belum Ada Voucher Nih :(',
            subTitle:
                'Ayo semangat lagi mainnya supaya dapet voucher dari mas slamet',
          ),
        ),
      ),
    );
  }
}
