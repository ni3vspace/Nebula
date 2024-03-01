import 'package:get/get.dart';
import 'package:nebula/utils/log_utils.dart';
import 'package:nebula/view/auth/splash/splash_controller.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {
    LogUtils.debugLog("SplashBinding");
    // TODO: implement dependencies
    // Get.lazyPut<SplashController>(() => SplashController());
    Get.put(SplashController());
  }

}