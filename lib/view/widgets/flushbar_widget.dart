import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar flushbarError(String message) => Flushbar(
      message: message,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2),
      messageSize: 12,
      backgroundColor: Colors.red,
    );
