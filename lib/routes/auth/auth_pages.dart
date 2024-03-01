import 'package:get/get.dart';
import 'package:nebula/view/auth/splash/splash_screen.dart';
import 'package:nebula/view/auth/Login/LoginPage.dart';

import '../../view/auth/auth_binding.dart';
import '../../view/auth/splash/splash_binding.dart';
import '../app_pages.dart';

class AuthPages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () =>  LoginPage(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.login,
    //   page: () => LoginScreen(),
    //   binding: AuthBinding(),
    // ),

  ];
}
