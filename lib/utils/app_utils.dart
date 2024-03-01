import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nebula/utils/user_pref.dart';

import 'log_utils.dart';


class AppUtils {
  checkForFCMUpdate() async {
    String userId = await UserPref.userId;
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    LogUtils.debugLog("userId: $userId");
    LogUtils.debugLog("FCM Token: $fcmToken");
    if (userId != "" && fcmToken != null) {
      String existingToken = await UserPref.fcmToken;
      LogUtils.debugLog("existingToken: $existingToken");
      if (fcmToken != existingToken) {
        // uploadFCMTokenToServer();
      }
    }
  }
}
