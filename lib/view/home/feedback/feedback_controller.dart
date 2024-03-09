import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/color_constants.dart';

class FeedbackController extends GetxController{

  FeedbackController();
  TextEditingController textEditingController = TextEditingController();
  @override
  void onInit() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: ColorConstants.back_black, // Set the color of status bar
    // ));
    super.onInit();

  }

  void resetStatusBarColor(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
}