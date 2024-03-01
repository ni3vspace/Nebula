
class Strings {
  static final Strings _singleton = Strings._internal();

  factory Strings() {
    return _singleton;
  }

  Strings._internal();

  static String nebula = "Nebula";
  static String baseUrl = "Nebula";
}
