import 'package:get/get.dart';
import 'package:nebula/api/api_provider.dart';
import 'package:nebula/view/auth/splash/splash_controller.dart';
import '../../api/repository/authanctiation_repo.dart';
import 'Login/LoginController.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(authanticationRepo:AuthanticationRepo(apiProvider: Get.find())));

  }
}
