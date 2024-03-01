import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/log_utils.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  SplashController();
  @override
  void onInit() {
    LogUtils.debugLog("SplashController init");
    super.onInit();

  }

  @override
  void onReady() {
    LogUtils.debugLog("SplashController onReady");
    Future.delayed(const Duration(seconds: 4), () async {
      Get.offNamed(Routes.login);
    });
    super.onReady();
  }
}