
import 'package:nebula/utils/preferences_helper.dart';
import 'package:nebula/utils/storage.dart';

class UserPref {

  static Future saveUserId(String value) async {
    await PreferencesHelper.setString(StorageConstants.userId, value);
    // await extractDetailsFromToken(value);
  }
  static Future saveUserName(String value) async {
    await PreferencesHelper.setString(StorageConstants.userName, value);
    // await extractDetailsFromToken(value);
  }

  static Future<String> get userId =>
      PreferencesHelper.getString(StorageConstants.userId);

  static Future<String> get userName =>
      PreferencesHelper.getString(StorageConstants.userName);

  static Future<String> get fcmToken =>
      PreferencesHelper.getString(StorageConstants.fcmToken);

  static Future saveFCMToken(String value) async {
    await PreferencesHelper.setString(StorageConstants.fcmToken, value);
  }

  static Future<void> clear() async {
    await PreferencesHelper.clear();
  }

}
