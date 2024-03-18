import 'package:nebula/routes/all_event/all_event_page.dart';
import 'package:nebula/routes/home/home_pages.dart';

import 'auth/auth_pages.dart';
import 'disclaimer/disclaimer_pages.dart';

part 'app_routes.dart';

class AppPages {
  static final routes =
      AuthPages.routes +
      DisclaimerPages.routes +
      HomePages.routes +
      AllEventPage.routes ;
}
