import 'package:get/get.dart';
import 'package:nebula/view/disclaimer/disclaimer_controller.dart';

class DisclaimerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisclaimerController>(
        () => DisclaimerController());

  }
}
