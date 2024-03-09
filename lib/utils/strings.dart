
class Strings {
  static final Strings _singleton = Strings._internal();

  factory Strings() {
    return _singleton;
  }

  Strings._internal();

  static String nebula = "Nebula";
  static String baseUrl = "https://3ux3va99g5.execute-api.us-east-1.amazonaws.com";
  static String api_key = "CKuz5fLE4U7PZpNDMNN3H1xuzwEM0QLu5irSteZh";
  static String reminder = "Reminder";
  static String make_reminder = "Make a reminder";
  static String noInternetConnection = "No Internet Connection";
  static String loading = "Loading...";
  static String done = "done";
  static String save = "Save";
  static String feedback = "Feedback";
  static String all_reminders = "ALL REMINDERS";
  static String feedback_enter = "Enter your feedback here";

  static String event = "Event";
  static String location = "Location";
  static String description = "Description";
  static String timDateVenue = "TIME & DATE";
  static String add_to_reminder = "ADD TO REMINDER";
  static String no_reminder = "No reminder found";
  static String retry = "Retry";

  //messages
  static String addedCalender = "Your reminder has been set!";
  static String feedback_title = "We value your feedback! Let us know what you liked or disliked about the app to help us improve your experience.";
}
