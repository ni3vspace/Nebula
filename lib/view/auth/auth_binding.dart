import 'package:get/get.dart';
import 'package:nebula/view/auth/splash/splash_controller.dart';
import 'Login/LoginController.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController());

  }
}
