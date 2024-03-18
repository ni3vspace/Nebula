import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:nebula/view/disclaimer/disclaimer_binding.dart';
import 'package:nebula/view/disclaimer/disclaimer_screen.dart';

import '../app_pages.dart';

class DisclaimerPages {
  static final routes = [
    GetPage(
      name: Routes.disclaimer,
      page: () => const DisclaimerScreen(),
      binding: DisclaimerBinding(),
    ),


  ];
}
