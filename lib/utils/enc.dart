import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:isilahtitiktitik/constant/constant.dart';

String encryptAES(int timestamp, int gmt) {
  final app = Platform.isAndroid ? 'app_android' : 'app_ios';
  final username = '$usernm||$app||$version||$timestamp||$gmt';
  final bytes = sha256.convert(utf8.encode('$timestamp$passwd'));
  final key = Key.fromUtf8(bytes.toString().substring(0, 32));
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  final encrypted = encrypter.encrypt(username, iv: iv);

  return '${iv.base64}:${encrypted.base64}';
}
