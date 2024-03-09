import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nebula/utils/strings.dart';
import 'package:nebula/utils/user_pref.dart';
import 'package:http/http.dart' as http;
import '../api/responses/api_response.dart';
import '../api/responses/bad_request_error.dart';
import '../api/responses/error_response.dart';
import '../api/responses/unhandle_error.dart';
import 'color_constants.dart';
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

  static getToast(
      {required String message,
        bool isError = false,
        ToastGravity toastGravity = ToastGravity.BOTTOM,
        Toast? length = Toast.LENGTH_SHORT}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        gravity: toastGravity,
        backgroundColor: isError ? Colors.red : ColorConstants.pinOnCamera,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static handleApiError(ApiResponse response) {
    try {
      switch (response.statusCode) {
        case 0:
          break;
        case 400:
          getToast(
              message: (response.data).errors.first,
              isError: true,
              toastGravity: ToastGravity.BOTTOM);
          break;

        case 401:
          getToast(
              message: "401",
              isError: true,
              toastGravity: ToastGravity.BOTTOM);
          // AppUtils.logoutUser(Strings.sessionExpired);
          break;
        case 403:
        case 500:
          getToast(
              message: response.data,
              isError: true,
              toastGravity: ToastGravity.BOTTOM);
          break;
        default:
          getToast(
              message: response.data,
              isError: true,
              toastGravity: ToastGravity.BOTTOM);
          break;
      }
    } catch (e) {
      getToast(
          message: "Error Occurred!!!",
          isError: true,
          toastGravity: ToastGravity.BOTTOM);
      // FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  static dynamic getApiResponse(Response response) {
    try {
      if (response.statusCode != null) {
        switch (response.statusCode) {
          case 200:
          case 201:
            var responseJson = ApiResponse.success(
                response.statusCode, response.body,
                headers: response.headers);
            return responseJson;

          case 400:
            // FirebaseCrashlytics.instance
            //     .recordError(AppUtils.networkResponseAsString(response), null);
            return ApiResponse.error(
                response.statusCode, ErrorResponse.fromJson(response.body),
                headers: response.headers);

          case 401:
          //AppUtils.logoutUser(Strings.sessionExpired); // we handle app utils on handleApiError
            return "";
          case 403:
          case 500:
            // FirebaseCrashlytics.instance
            //     .recordError(AppUtils.networkResponseAsString(response), null);
            String? message;
            try {
              message = BadRequestError.fromJson(response.body[0]).details;
            } catch (e) {
              message = UnHandledError.fromJson(response.body).error;
            }
            return ApiResponse.error(response.statusCode, message.toString(),
                headers: response.headers);

          default:
            // FirebaseCrashlytics.instance
            //     .recordError(AppUtils.networkResponseAsString(response), null);
            return ApiResponse.error(response.statusCode,
                '${response.statusCode} : Error Occurred: ${response.bodyString}',
                headers: response.headers);
        }
      } else {
        return ApiResponse.error(0, 'Error: ${response.statusText.toString()}',
            headers: response.headers);
      }
    } catch (e) {
      // FirebaseCrashlytics.instance
      //     .recordError("Unable to Parse Error: $e", null);
      return ApiResponse.error(1, "Unable to Parse Error",
          headers: response.headers);
    }
  }

  static getApiError(ApiResponse response) {
    try {
      switch (response.statusCode) {
        case 0:
          return "Unable to load, please try again";
        case 400:
          return (response.data).errors.first.toString();
        case 401:
          return "";
          // AppUtils.logoutUser(Strings.sessionExpired);
          break;
        case 403:
        case 500:
          return response.data.toString();
        default:
          return response.data.toString();
      }
    } catch (e) {
      // FirebaseCrashlytics.instance.recordError(e, null);
      return "Error Occurred: ${e.toString()}";
    }
  }

  static Future<ApiResponse> uploadDocument(
      String filename, String filePath) async {
    try {
      String userName=await UserPref.userName;
      Uri url = Uri.parse(Strings.baseUrl+"/Prod/event/process");
      http.MultipartRequest request = http.MultipartRequest('POST', url);

      request.headers['Content-type'] = "application/json";
      request.headers['x-api-key'] = Strings.api_key;
      request.headers['userName'] = userName;

      request.fields['filename'] = filename;
      request.fields['mimetype'] = "image/jpeg";
      Uint8List fileBytes = await File(filePath).readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes,
          filename: filename));

      http.StreamedResponse response = await request.send();

      log("${request.headers}");
      log("${request.fields} \n${request.method} ${request.url}");

      log("Status:${response.statusCode}\n Response: ${response.stream.toString()}");
      if (response.statusCode == 201) {
        String responseBody = await response.stream.bytesToString();
        return ApiResponse.success(201, responseBody);
      } else {
        String errorBody = await response.stream.bytesToString();
        LogUtils.error(errorBody);
        // await FirebaseCrashlytics.instance.recordError(
        //     "Document upload failed: $errorBody", null);
        return ApiResponse.error(response.statusCode, errorBody);
      }
    } catch (e) {
      debugPrint("uploadDocument Exception=" + e.toString());
      return ApiResponse.error(1, "Error Occurred : ${e.toString()}");
    }
  }
}
