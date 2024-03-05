import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/color_constants.dart';

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

roundedDialog(Widget widget) {
  AlertDialog alert = AlertDialog(
    backgroundColor:ColorConstants.back_black,
    contentPadding: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: widget,
  );
  Get.dialog(alert, barrierDismissible: false);
}