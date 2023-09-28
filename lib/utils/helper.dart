import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class IsilahHelper {
  static String formatCurrency(double number) {
    final NumberFormat fmt =
        NumberFormat.currency(locale: 'id', symbol: 'Rp. ');
    String s = fmt.format(number);
    String format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return format;
  }

  static String formatCurrencyWithoutSymbol(double? number) {
    final NumberFormat fmt = NumberFormat.currency(locale: 'id', symbol: '');
    String s = fmt.format(number);
    String format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return format;
  }

  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMd("id").format(dateTime);
  }

  static String formatDates(DateTime dateTime) {
    initializeDateFormatting("id");
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(dateTime);
    return outputDate;
  }

  static String formatDateHms(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat("yyyy-MM-dd HH:mm:ss", "id").format(dateTime);
  }

  static String formatLongDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static String formatMiddleDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.MMMMEEEEd("id").format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.MMMMd("id").format(dateTime);
  }

  static String formatVeryShort(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.MMMM("id").format(dateTime);
  }

  static String formatVeryShort2(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.MMMd("id").format(dateTime);
  }

  static String formatYears(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.y("id").format(dateTime);
  }

  static String formatDayAndMonth(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMMM');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String formatDayMonthYear(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String formatDays(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMMM', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String formatDaysFull(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMMM yyyy', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String formatDaysUndian(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMMM yyyy', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText
        .replaceAll(exp, '')
        .replaceAll('&nbsp;', '')
        .replaceAll('&amp;', '')
        .replaceAll('&lsquo;', '')
        .replaceAll('&rsquo;', '')
        .replaceAll('&ldquo;', '')
        .replaceAll('\n', '');
  }
}

extension DioErrorX on DioError {
  bool get isNoConnectionError =>
      type == DioErrorType.other &&
      error is SocketException; // import 'dart:io' for SocketException
}
