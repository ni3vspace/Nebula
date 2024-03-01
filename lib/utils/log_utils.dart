import 'dart:developer';

import 'package:flutter/foundation.dart';

class LogUtils {
  @pragma("vm:prefer-inline")
  static Future<void> error(dynamic e, {StackTrace? s}) async {
    if (kDebugMode) {
      log(e.toString());
    }
  }

  static Future<void> debugLog(dynamic e) async {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}