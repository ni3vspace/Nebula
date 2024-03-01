import 'package:get/get.dart';
import 'package:nebula/view/auth/splash/splash_screen.dart';
import 'package:nebula/view/auth/Login/LoginPage.dart';
import 'package:nebula/view/home/home_binding.dart';
import 'package:nebula/view/home/home_controller.dart';
import 'package:nebula/view/home/home_screen.dart';

import '../../view/auth/auth_binding.dart';
import '../../view/auth/splash/splash_binding.dart';
import '../app_pages.dart';

class HomePages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),


  ];
}
