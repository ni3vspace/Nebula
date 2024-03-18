
class Strings {
  static final Strings _singleton = Strings._internal();

  factory Strings() {
    return _singleton;
  }

  Strings._internal();

  static String nebula = "Nebula";
  static String baseUrl = "https://3ux3va99g5.execute-api.us-east-1.amazonaws.com";
  static String feedbackAdd = "https://m4ybtrdhkf.execute-api.us-east-1.amazonaws.com/Prod/feedback/add";
  static String userCreate = "https://j4s9xi4qxj.execute-api.us-east-1.amazonaws.com/Prod/user/create";
  static String api_key = "CKuz5fLE4U7PZpNDMNN3H1xuzwEM0QLu5irSteZh";
  static String api_key1 = "YAxqZ6JxVQ9rQ0eVKW3BFVLEAe7T8JJaqzQ6QlQb";
  static String reminder = "Reminder";
  static String classroom = "Classroom";
  static String make_reminder = "Make a reminder";
  static String noInternetConnection = "No Internet Connection";
  static String loading = "Loading...";
  static String done = "done";
  static String save = "Save";
  static String delete = "Delete";
  static String feedback = "Feedback";
  static String all_reminders = "ALL REMINDERS";
  static String feedback_enter = "Enter your feedback here";
  static String feedback_enter_error = "Please enter feedback";

  static String actionPopUp = "Where do you want to add this?";

  static String event = "Event";
  static String location = "Location";
  static String description = "Description";
  static String timDateVenue = "TIME & DATE";
  static String add_to_reminder = "ADD TO REMINDER";
  static String no_reminder = "No reminder found";
  static String retry = "Retry";

  //messages
  static String someThingWentWrong = "Some thing went wrong";
  static String addedCalender = "Your reminder has been set!";
  static String addedFeedback = "Your feedback has been submit successfully!";
  static String feedback_title = "We value your feedback! Let us know what you liked or disliked about the app to help us improve your experience.";
}
