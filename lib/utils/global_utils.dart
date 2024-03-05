
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nebula/utils/log_utils.dart';
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

  static Future<XFile?> pickImage() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    return image;
  }

  static String getDateInDMYFormat(DateTime? datetime) {
    if (datetime == null) {
      return "";
    }
    return DateFormat('dd-MM-yy').format(datetime);
  }
  static String getTimeFormat(String? str) {
    try{
      if (str == null) {
        return "";
      }
      LogUtils.debugLog(DateTime.now().toString());
      return DateFormat('hh:mm a').format(DateTime.parse("2023-06-14 $str"));
    }catch(e){
      LogUtils.error(e.toString());
      return "";
    }
  }

  static String getDateMonthYearString(String? str,{bool getDayOfMonthSuffixes=false}) {
    if (str == null) {
      return "";
    }
    try{
      DateTime dateTime=DateTime.parse(str);
      List months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      List weekDays = [
        'Mon',
        'Tue',
        'Wed',
        'Thur',
        'Fri',
        'Sat',
        'Sun'
      ];
      // DateTime datetime = (date as Timestamp).toDate();
      // DateTime parseDateTime =
      // DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime.toString());
      // var time = DateFormat("hh:mm a").format(parseDateTime);
      return "${weekDays[dateTime.weekday-1]}, ${ months[dateTime.month - 1]} ${dateTime.day} ${getDayOfMonthSuffixes?getDayOfMonthSuffix(dateTime.day)+" ":""}" +

          ", " +
          dateTime.year
              .toString() /*+
          ", " +
          datetime.year.toString()*/
      ;
    }catch(e){
      LogUtils.debugLog(("getDateMonthYearString Exception e=="+e.toString()));
      return "";
    }
  }
  static String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String? getServerDate(String? date) {
    if(date==null || date.isEmpty){
      return null;
    }
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
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
