import 'package:nebula/routes/home/home_pages.dart';

import 'auth/auth_pages.dart';

part 'app_routes.dart';

class AppPages {
  static final routes =
      AuthPages.routes +
      HomePages.routes ;
}
