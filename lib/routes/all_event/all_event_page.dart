import 'package:get/get.dart';
import 'package:nebula/view/home/home_binding.dart';
import 'package:nebula/view/home/home_screen.dart';
import '../../view/all_events/all_event_binding.dart';
import '../../view/all_events/all_events_screen.dart';
import '../app_pages.dart';

class AllEventPage {
  static final routes = [
    GetPage(
      name: Routes.event_list,
      page: () => AllEventsScreen(),
      binding: AllEventBinding(),
    ),


  ];
}
