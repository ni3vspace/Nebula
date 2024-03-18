import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/user_pref.dart';

import '../../../api/repository/reminder_repo.dart';
import '../../../api/responses/api_response.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/log_utils.dart';
import '../../../utils/preferences_helper.dart';
import '../../../utils/storage.dart';
import '../../../utils/strings.dart';
import '../../../utils/widgets/common_widgets.dart';

class FeedbackController extends GetxController{

  FeedbackController();
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: ColorConstants.back_black, // Set the color of status bar
    // ));
    super.onInit();

  }

  void resetStatusBarColor(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  Future<void> callApi(ReminderRepo reminderRepo,String feedbackDescription) async {
    showLoadingDialog();
    try {
      String mail=await PreferencesHelper.getString(
          StorageConstants.userEmail);
      ApiResponse response=await reminderRepo.callFeedbackCreate(feedbackDescription,mail);

      switch (response.status) {
        case Status.SUCCESS:
          // LoginSuccess loginSuccess=LoginSuccess.fromJson(response.data);
          Navigator.pop(Get.overlayContext!);//pop progress
          SuccessDialogScreen(Strings.addedFeedback);

          break;
        case Status.ERROR:
          Navigator.pop(Get.overlayContext!);//pop progress
          // AppUtils.getToast(message: response.data.toString(), isError: true);
          LogUtils.error(response.data.toString());
          AppUtils.handleApiError(response);
          // Navigator.pop(Get.overlayContext!);
          break;
      }
    } catch (e) {
      Navigator.pop(Get.overlayContext!);//pop progress
      LogUtils.error(e);
      // Navigator.pop(Get.overlayContext!);
      AppUtils.getToast(message: e.toString(), isError: true);
    }
  }
}