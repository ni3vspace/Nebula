
import 'package:get/get.dart';
import 'package:nebula/api/repository/all_events_repo.dart';

import 'all_events_controller.dart';

class AllEventBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllEventsController>(
            () => AllEventsController(allEventsRepo: AllEventsRepo(apiProvider: Get.find()),));

  }
}
