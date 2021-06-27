import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  static void showDialog(String text) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(text),
      ),
    );
  }
}
