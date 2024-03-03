
class Strings {
  static final Strings _singleton = Strings._internal();

  factory Strings() {
    return _singleton;
  }

  Strings._internal();

  static String nebula = "Nebula";
  static String baseUrl = "https://3ux3va99g5.execute-api.us-east-1.amazonaws.com/";
  static String api_key = "CKuz5fLE4U7PZpNDMNN3H1xuzwEM0QLu5irSteZh";
  static String reminder = "Reminder";
  static String make_reminder = "Make a reminder";
  static String noInternetConnection = "No Internet Connection";
  static String loading = "Loading...";
}
