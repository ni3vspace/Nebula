
import 'package:get/get.dart';
import 'package:nebula/api/repository/reminder_repo.dart';

import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
            () => HomeController(reminderRepo: ReminderRepo(apiProvider: Get.find()),));

  }
}
