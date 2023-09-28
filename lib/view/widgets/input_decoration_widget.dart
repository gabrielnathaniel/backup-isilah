import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';

InputDecoration inputDecoration(String hintText) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: ColorPalette.neutral_50,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w400,
        fontSize: bodySmall,
      ),
      contentPadding:
          const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorPalette.neutral_40),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.mainColor)),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    );
