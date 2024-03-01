
import 'package:nebula/utils/user_pref.dart';

import 'app_utils.dart';

class GlobalUtils {
  static GlobalUtils _instance = GlobalUtils._internal();
  static String entity = "lead";
  static String entities = "leads";
  static String Entity = "Lead";
  static String Entities = "Leads";
  static bool hasAdminAccess = false;
  static bool isServiceBusiness = false;
  static bool isOwner = false;
  static bool supportsCompanyType = false;

  factory GlobalUtils() {
    return _instance;
  }

  GlobalUtils._internal() {}

  Future<void> init() async {
    // String businessType = await UserPref.businessType;


    // hasAdminAccess = await AppUtils.hasAdminAccess();
    // isOwner = await AppUtils.isOwner();

  }

}
enum CamerasEnum {
  FRONT_CAMERA,//1
  BACK_CAMERA//0
}
extension CamerasExtension on CamerasEnum {
  int getCameraVal() {
    switch (this) {
      case CamerasEnum.FRONT_CAMERA:
        return 1;
      case CamerasEnum.BACK_CAMERA:
        return 0;
      default:
        return 0;
    }
  }
}

//Service
