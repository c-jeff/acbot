import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBarSuccess (String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text, style: const TextStyle(color: Colors.white),), backgroundColor: Colors.green);

    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }

  static showSnackBarError (String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text, style: const TextStyle(color: Colors.white),), backgroundColor: Colors.red);

    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}