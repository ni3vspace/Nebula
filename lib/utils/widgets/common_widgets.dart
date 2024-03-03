import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../strings.dart';

showLoadingDialog() {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 8),
            child: Text(
              Strings.loading,
            )),
      ],
    ),
  );
  Get.dialog(alert, barrierDismissible: false);
}